package Net::Amazon::S3::Client::Bucket;

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
use Data::Stream::Bulk::Callback;
use MooseX::Types::DateTime::MoreCoercions 0.07 qw( DateTime );

# ABSTRACT: An easy-to-use Amazon S3 client bucket

has 'client' =>
    ( is => 'ro', isa => 'Net::Amazon::S3::Client', required => 1 );
has 'name' => ( is => 'ro', isa => 'Str', required => 1 );
has 'creation_date' =>
    ( is => 'ro', isa => DateTime, coerce => 1, required => 0 );
has 'owner_id'           => ( is => 'ro', isa => 'OwnerId', required => 0 );
has 'owner_display_name' => ( is => 'ro', isa => 'Str',     required => 0 );

__PACKAGE__->meta->make_immutable;

sub _create {
    my ( $self, %conf ) = @_;

    my $http_request = Net::Amazon::S3::Request::CreateBucket->new(
        s3                  => $self->client->s3,
        bucket              => $self->name,
        acl_short           => $conf{acl_short},
        location_constraint => $conf{location_constraint},
    )->http_request;

    $self->client->_send_request($http_request);
}

sub delete {
    my $self         = shift;
    my $http_request = Net::Amazon::S3::Request::DeleteBucket->new(
        s3     => $self->client->s3,
        bucket => $self->name,
    )->http_request;

    $self->client->_send_request($http_request);
}

sub acl {
    my $self = shift;

    my $http_request = Net::Amazon::S3::Request::GetBucketAccessControl->new(
        s3     => $self->client->s3,
        bucket => $self->name,
    )->http_request;

    return $self->client->_send_request_content($http_request);
}

sub location_constraint {
    my $self = shift;

    my $http_request
        = Net::Amazon::S3::Request::GetBucketLocationConstraint->new(
        s3     => $self->client->s3,
        bucket => $self->name,
        )->http_request;

    my $xpc = $self->client->_send_request_xpc($http_request);

    my $lc = $xpc->findvalue('/s3:LocationConstraint');
    if ( defined $lc && $lc eq '' ) {
        $lc = 'US';
    }
    return $lc;
}

sub object_class { 'Net::Amazon::S3::Client::Object' }

sub list {
    my ( $self, $conf ) = @_;
    $conf ||= {};
    my $prefix = $conf->{prefix};
    my $delimiter = $conf->{delimiter};

    my $marker = undef;
    my $end    = 0;

    return Data::Stream::Bulk::Callback->new(
        callback => sub {

            return undef if $end;

            my $http_request = Net::Amazon::S3::Request::ListBucket->new(
                s3     => $self->client->s3,
                bucket => $self->name,
                marker => $marker,
                prefix => $prefix,
                delimiter => $delimiter,
            )->http_request;

            my $xpc = $self->client->_send_request_xpc($http_request);

            my @objects;
            foreach my $node (
                $xpc->findnodes('/s3:ListBucketResult/s3:Contents') )
            {
                my $etag = $xpc->findvalue( "./s3:ETag", $node );
                $etag =~ s/^"//;
                $etag =~ s/"$//;

 #            storage_class => $xpc->findvalue( ".//s3:StorageClass", $node ),
 #            owner_id      => $xpc->findvalue( ".//s3:ID",           $node ),
 #            owner_displayname =>
 #                $xpc->findvalue( ".//s3:DisplayName", $node ),

                push @objects,
                    $self->object_class->new(
                    client => $self->client,
                    bucket => $self,
                    key    => $xpc->findvalue( './s3:Key', $node ),
                    last_modified_raw =>
                        $xpc->findvalue( './s3:LastModified', $node ),
                    etag => $etag,
                    size => $xpc->findvalue( './s3:Size', $node ),
                    );
            }

            return undef unless @objects;

            my $is_truncated
                = scalar $xpc->findvalue(
                '/s3:ListBucketResult/s3:IsTruncated') eq 'true'
                ? 1
                : 0;
            $end = 1 unless $is_truncated;

            $marker = $xpc->findvalue('/s3:ListBucketResult/s3:NextMarker')
                || $objects[-1]->key;

            return \@objects;
        }
    );
}

sub versions {
    my ( $self, $conf ) = @_;
    $conf ||= {};
    my $prefix = $conf->{prefix};
    my $delimiter = $conf->{delimiter};

    my $marker = undef;
    my $end    = 0;

    return Data::Stream::Bulk::Callback->new(
        callback => sub {

            return undef if $end;

            my $http_request = Net::Amazon::S3::Request::ListVersions->new(
                s3     => $self->client->s3,
                bucket => $self->name,
                marker => $marker,
                prefix => $prefix,
                delimiter => $delimiter,
            )->http_request;
            
            my $xpc = $self->client->_send_request_xpc($http_request);

            my @objects;
            foreach my $node (
                $xpc->findnodes('/s3:ListVersionsResult/s3:Version') ) {
                my $etag = $xpc->findvalue( "./s3:ETag", $node );
                $etag =~ s/^"//;
                $etag =~ s/"$//;

                my $obj =
                    $self->object_class->new(
                    client => $self->client,
                    bucket => $self,
                    key    => $xpc->findvalue( './s3:Key', $node ),
                    last_modified_raw =>
                        $xpc->findvalue( './s3:LastModified', $node ),
                    etag => $etag,
                    size => $xpc->findvalue( './s3:Size', $node ),
                    );
                $obj->user_metadata->{version_id} = $xpc->findvalue('./s3:VersionId', $node);
                $obj->user_metadata->{is_latest} = $xpc->findvalue('./s3:IsLatest', $node);
                push @objects, $obj;
            }
            foreach my $node (
                $xpc->findnodes('/s3:ListVersionResult/s3:DeleteMarker') ) {
                my $etag = $xpc->findvalue( "./s3:ETag", $node );
                $etag =~ s/^"//;
                $etag =~ s/"$//;

                my $obj =
                    $self->object_class->new(
                    client => $self->client,
                    bucket => $self,
                    key    => $xpc->findvalue( './s3:Key', $node ),
                    last_modified_raw =>
                        $xpc->findvalue( './s3:LastModified', $node ),
                    etag => '',
                    size => -1,
                    );
                $obj->user_metadata->{version_id} = $xpc->findvalue('./s3:VersionId', $node);
                $obj->user_metadata->{is_latest} = $xpc->findvalue('./s3:IsLatest', $node);
                $obj->user_metadata->{delete_marker} = 1;
                push @objects, $obj;
            }

            return undef unless @objects;

            my $is_truncated
                = scalar $xpc->findvalue(
                '/s3:ListBucketResult/s3:IsTruncated') eq 'true'
                ? 1
                : 0;
            $end = 1 unless $is_truncated;

            $marker = $xpc->findvalue('/s3:ListBucketResult/s3:NextMarker')
                || $objects[-1]->key;

            return \@objects;
        }
    );
}

sub list_uploads {
    my ( $self, $conf ) = @_;
    $conf ||= {};

    my $http_request = Net::Amazon::S3::Request::ListAllParts->new(
        s3     => $self->client->s3,
        bucket => $self->name,
        marker => $conf->{marker},
        prefix => $conf->{prefix},
        delimiter => $conf->{delimiter},
    )->http_request;

    my $xpc = $self->client->_send_request_xpc($http_request);
    my @objects;
    foreach my $node ( $xpc->findnodes('/s3:ListMultipartUploadsResult/s3:Upload') ) {
        my $key = $xpc->findvalue( "./s3:Key", $node );
        push @objects,
            {
                key       => $xpc->findvalue( './s3:Key', $node ),
                uploadID  => $xpc->findvalue( './s3:UploadId', $node ),
                initiated => $xpc->findvalue( './s3:Initiated', $node ),
                # storageclass => $xpc->findvalue( './s3:StorageClass', $node ),
            }
    }

    return @objects;
}

sub delete_multi_object {
    my $self = shift;
    my @objects = @_;
    return unless( scalar(@objects) );

    # Since delete can handle up to 1000 requests, be a little bit nicer
    # and slice up requests and also allow keys to be strings
    # rather than only objects.
    my $last_result;
    while (scalar(@objects) > 0) {
        my $http_request = Net::Amazon::S3::Request::DeleteMultiObject->new(
            s3      => $self->client->s3,
            bucket  => $self->name,
            keys    => [map {
                if (ref($_)) {
                    $_->key
                } else {
                    $_
                }
            } splice @objects, 0, ((scalar(@objects) > 1000) ? 1000 : scalar(@objects))]
        )->http_request;

        $last_result = $self->client->_send_request($http_request);

        if (!$last_result->is_success()) {
            last;
        }
    }
    return $last_result;
}

sub object {
    my ( $self, %conf ) = @_;
    return $self->object_class->new(
        client => $self->client,
        bucket => $self,
        %conf,
    );
}


1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  # return the bucket name
  print $bucket->name . "\n";

  # return the bucket location constraint
  print "Bucket is in the " . $bucket->location_constraint . "\n";

  # return the ACL XML
  my $acl = $bucket->acl;

  # list objects in the bucket
  # this returns a L<Data::Stream::Bulk> object which returns a
  # stream of L<Net::Amazon::S3::Client::Object> objects, as it may
  # have to issue multiple API requests
  my $stream = $bucket->list;
  until ( $stream->is_done ) {
    foreach my $object ( $stream->items ) {
      ...
    }
  }

  # or list by a prefix
  my $prefix_stream = $bucket->list( { prefix => 'logs/' } );

  # returns a L<Net::Amazon::S3::Client::Object>, which can then
  # be used to get or put
  my $object = $bucket->object( key => 'this is the key' );

  # delete the bucket (it must be empty)
  $bucket->delete;

=head1 DESCRIPTION

This module represents buckets.

=head1 METHODS

=head2 acl

  # return the ACL XML
  my $acl = $bucket->acl;

=head2 delete

  # delete the bucket (it must be empty)
  $bucket->delete;

=head2 list

  # list objects in the bucket
  # this returns a L<Data::Stream::Bulk> object which returns a
  # stream of L<Net::Amazon::S3::Client::Object> objects, as it may
  # have to issue multiple API requests
  my $stream = $bucket->list;
  until ( $stream->is_done ) {
    foreach my $object ( $stream->items ) {
      ...
    }
  }

  # or list by a prefix
  my $prefix_stream = $bucket->list( { prefix => 'logs/' } );

  # you can emulate folders by using prefix with delimiter
  # which shows only entries starting with the prefix but
  # not containing any more delimiter (thus no subfolders).
  my $folder_stream = $bucket->list( { prefix => 'logs/', delimiter => '/' } );

=head2 location_constraint

  # return the bucket location constraint
  print "Bucket is in the " . $bucket->location_constraint . "\n";

=head2 name

  # return the bucket name
  print $bucket->name . "\n";

=head2 object

  # returns a L<Net::Amazon::S3::Client::Object>, which can then
  # be used to get or put
  my $object = $bucket->object( key => 'this is the key' );

=head2 delete_multi_object

  # delete multiple objects using a multi object delete operation
  # Accepts a list of L<Net::Amazon::S3::Client::Object or String> objects.
  $bucket->delete_multi_object($object1, $object2)

=head2 object_class

  # returns string "Net::Amazon::S3::Client::Object"
  # allowing subclasses to add behavior.
  my $object_class = $bucket->object_class;

