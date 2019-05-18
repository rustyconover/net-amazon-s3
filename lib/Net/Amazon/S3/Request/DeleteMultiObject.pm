package Net::Amazon::S3::Request::DeleteMultiObject;

use Moose 0.85;
use Digest::MD5 qw/md5 md5_hex/;
use MIME::Base64;
use Carp qw/croak/;

extends 'Net::Amazon::S3::Request::Bucket';

has 'keys'      => ( is => 'ro', isa => 'ArrayRef',   required => 1 );

with 'Net::Amazon::S3::Request::Role::Query::Action::Delete';
with 'Net::Amazon::S3::Request::Role::HTTP::Header::Content_length';
with 'Net::Amazon::S3::Request::Role::HTTP::Header::Content_md5';
with 'Net::Amazon::S3::Request::Role::HTTP::Header::Content_type' => { content_type => 'application/xml' };
with 'Net::Amazon::S3::Request::Role::HTTP::Method::POST';

__PACKAGE__->meta->make_immutable;

sub _request_content {
    my ($self) = @_;

    #build XML doc
    my $xml_doc = XML::LibXML::Document->new('1.0','UTF-8');
    my $root_element = $xml_doc->createElement('Delete');
    $xml_doc->addChild($root_element);
    $root_element->appendTextChild('Quiet'=>'true');
    #add content
    foreach my $key (@{$self->keys}){
        my $obj_element = $xml_doc->createElement('Object');
        $obj_element->appendTextChild('Key' => $key);
        $root_element->addChild($obj_element);
    }

    return $xml_doc->toString;
}

sub BUILD {
    my ($self) = @_;

    croak "The maximum number of keys is 1000"
        if (scalar(@{$self->keys}) > 1000);
}

1;

__END__

# ABSTRACT: An internal class to delete multiple objects from a bucket

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  my $http_request = Net::Amazon::S3::Request::DeleteMultiObject->new(
    s3                  => $s3,
    bucket              => $bucket,
    keys                => [$key1, $key2],
  )->http_request;

=head1 DESCRIPTION

This module deletes multiple objects from a bucket.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.
