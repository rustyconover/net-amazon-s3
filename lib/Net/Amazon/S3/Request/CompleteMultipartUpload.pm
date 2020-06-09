package Net::Amazon::S3::Request::CompleteMultipartUpload;

use Moose 0.85;
use Digest::MD5 qw/md5 md5_hex/;
use MIME::Base64;
use Carp qw/croak/;
use XML::LibXML;

extends 'Net::Amazon::S3::Request::Object';

with 'Net::Amazon::S3::Request::Role::Query::Param::Upload_id';
with 'Net::Amazon::S3::Request::Role::HTTP::Header::Content_length';
with 'Net::Amazon::S3::Request::Role::HTTP::Header::Content_md5';
with 'Net::Amazon::S3::Request::Role::HTTP::Header::Content_type' => { content_type => 'application/xml' };
with 'Net::Amazon::S3::Request::Role::HTTP::Method::POST';

has 'etags'         => ( is => 'ro', isa => 'ArrayRef',   required => 1 );
has 'part_numbers'  => ( is => 'ro', isa => 'ArrayRef',   required => 1 );

__PACKAGE__->meta->make_immutable;

sub _request_content {
    my ($self) = @_;

    #build XML doc
    my $xml_doc = XML::LibXML::Document->new('1.0','UTF-8');
    my $root_element = $xml_doc->createElement('CompleteMultipartUpload');
    $xml_doc->addChild($root_element);

    #add content
    for(my $i = 0; $i < scalar(@{$self->part_numbers}); $i++ ){
        my $part = $xml_doc->createElement('Part');
        $part->appendTextChild('PartNumber' => $self->part_numbers->[$i]);
        $part->appendTextChild('ETag' => $self->etags->[$i]);
        $root_element->addChild($part);
    }

    return $xml_doc->toString;
}

sub BUILD {
    my ($self) = @_;

    croak "must have an equally sized list of etags and part numbers"
        unless scalar(@{$self->part_numbers}) == scalar(@{$self->etags});
}

1;

__END__

# ABSTRACT: An internal class to complete a multipart upload

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  my $http_request = Net::Amazon::S3::Request::CompleteMultipartUpload->new(
    s3                  => $s3,
    bucket              => $bucket,
    etags               => \@etags,
    part_numbers        => \@part_numbers,
  )->http_request;

=head1 DESCRIPTION

This module completes a multipart upload.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.
