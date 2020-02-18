package Shared::Examples::Net::Amazon::S3::Fixture;
# ABSTRACT: used for testing to provide test fixtures

use parent qw[ Exporter::Tiny ];

use HTTP::Status;

our @EXPORT_OK = (
    qw[ error_fixture ],
    qw[ response_fixture ],
    qw[ fixture ],
);

sub response_fixture {
    my (%params) = @_;

    return +{
        content_type   => 'application/xml',
        content_length => length $params{with_response_data},
        response_code  => HTTP::Status::HTTP_OK,

        %params,
    };
}

sub fixture {
    my (%params) = @_;

    return +{
        content_type   => 'application/xml',
        content_length => length $params{with_response_data},
        response_code  => HTTP::Status::HTTP_OK,

        %params,
    };
}

sub error_fixture {
    my ($error_code, $http_status) = @_;

    my $error_message = $error_code;
    $error_message =~ s/ (?<=[[:lower:]]) ([[:upper:]])/ \L$1\E/gx;

    return response_fixture (
        response_code => $http_status,
        content       => <<"XML",
<?xml version="1.0" encoding="UTF-8"?>
<Error>
  <Code>$error_code</Code>
  <Message>$error_message error message</Message>
  <Resource>/some-resource</Resource>
  <RequestId>4442587FB7D0A2F9</RequestId>
</Error>
XML
    );
}

1;

