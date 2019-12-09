package Net::Amazon::S3::Role::Bucket;
# ABSTRACT: Bucket role

use Moose::Role;
use Scalar::Util;

around BUILDARGS => sub {
    my ($orig, $class, %params) = @_;

    $params{region} = $params{bucket}->region
        if $params{bucket}
        and Scalar::Util::blessed( $params{bucket} )
        and ! $params{region}
        and $params{bucket}->has_region
        ;

    $params{bucket} = $params{bucket}->name
        if $params{bucket}
        and Scalar::Util::blessed( $params{bucket} )
        and $params{bucket}->isa( 'Net::Amazon::S3::Client::Bucket' )
        ;

    $params{bucket} = Net::Amazon::S3::Bucket->new(
        bucket => $params{bucket},
        account => $params{s3},
        (region => $params{region}) x!! $params{region},
    ) if $params{bucket} and ! ref $params{bucket};

    delete $params{region};

    $class->$orig( %params );
};

has bucket => (
    is => 'ro',
    isa => 'Net::Amazon::S3::Bucket',
    required => 1,
);

1;

