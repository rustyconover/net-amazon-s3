package Net::Amazon::S3::Request::RestoreObject;
# ABSTRACT: An internal class implementing RestoreObject operation

use strict;
use warnings FATAL => 'all';

use Moose;
use Moose::Util::TypeConstraints;

extends 'Net::Amazon::S3::Request::Object';
with 'Net::Amazon::S3::Request::Role::Query::Action::Restore';
with 'Net::Amazon::S3::Request::Role::HTTP::Header::Content_length';
with 'Net::Amazon::S3::Request::Role::HTTP::Header::Content_md5';
with 'Net::Amazon::S3::Request::Role::HTTP::Header::Content_type' => { content_type => 'application/xml' };
with 'Net::Amazon::S3::Request::Role::HTTP::Method::POST';

enum 'Tier' => [ qw(Standard Expedited Bulk) ];
has 'days' => (is => 'ro', isa => 'Int', required => 1);
has 'tier' => (is => 'ro', isa => 'Tier', required => 1);

__PACKAGE__->meta->make_immutable;

sub _request_content {
    my ($self) = @_;

    return '<RestoreRequest>'
        . '<Days>' . $self->days . '</Days>'
        . '<GlacierJobParameters><Tier>' . $self->tier . '</Tier></GlacierJobParameters>'
        . '</RestoreRequest>';
}

1;
