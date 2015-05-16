package Net::Amazon::S3::HTTPRequest;

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
use MIME::Base64 qw( encode_base64 );
use Moose::Util::TypeConstraints;
use URI::Escape qw( uri_escape_utf8 );
use URI::QueryParam;
use URI;
use VM::EC2::Security::CredentialCache;
use AWS::Signature4;

# ABSTRACT: Create a signed HTTP::Request

my $METADATA_PREFIX      = 'x-amz-meta-';

enum 'HTTPMethod' => [ qw(DELETE GET HEAD PUT POST) ];

has 's3'     => ( is => 'ro', isa => 'Net::Amazon::S3', required => 1 );
has 'method' => ( is => 'ro', isa => 'HTTPMethod',      required => 1 );
has 'path'   => ( is => 'ro', isa => 'Str',             required => 1 );
has 'headers' =>
    ( is => 'ro', isa => 'HashRef', required => 0, default => sub { {} } );
has 'content' =>
    ( is => 'ro', isa => 'Str|CodeRef|ScalarRef', required => 0, default => '' );
has 'metadata' =>
    ( is => 'ro', isa => 'HashRef', required => 0, default => sub { {} } );

__PACKAGE__->meta->make_immutable;

# make the HTTP::Request object
sub http_request {
    my $self     = shift;
    my $method   = $self->method;
    my $path     = $self->path;
    my $headers  = $self->headers;
    my $content  = $self->content;
    my $metadata = $self->metadata;

    my $http_headers = $self->_merge_meta( $headers, $metadata );

    my $protocol = $self->s3->secure ? 'https' : 'http';
    my $host = $self->s3->host;
    my $uri = "$protocol://$host/$path";


    my $request
        = HTTP::Request->new( $method, $uri, $http_headers, $content );

    if (!$headers->{Authorization}) {
        if ( not $http_headers->header('x-amz-security-token') and
             defined $self->s3->aws_session_token ) {
            $request->header( 'x-amz-security-token' => $self->s3->aws_session_token);
        }

        # need to send a signature of the content.
        print "Content is: " . $content . "\n";
        $request->header('x-amz-content-sha256', Digest::SHA::sha256_hex(defined($content) ? $content : ''));
        
        my $signer = $self->_get_signer();
        $signer->sign($request);
    }

    return $request;
}

sub _get_signer {
    my ($self) = @_;
    if ($self->s3->use_iam_role) {
        my $creds = VM::EC2::Security::CredentialCache->get();
        defined($creds) || die("Unable to retrieve IAM role credentials");
        $self->s3->aws_access_key_id($creds->accessKeyId);
        $self->s3->aws_secret_access_key($creds->secretAccessKey);
        $self->s3->aws_session_token($creds->sessionToken);
    }
    
    return AWS::Signature4->new(-access_key => $self->s3->aws_access_key_id,
                                -secret_key => $self->s3->aws_secret_access_key);
}

sub query_string_authentication_uri {
    my ( $self, $expires ) = @_;
    my $method  = $self->method;
    my $path    = $self->path;
    my $headers = $self->headers;

    my $signer = $self->_get_signer();

    my $protocol = $self->s3->secure ? 'https' : 'http';
    my $host = $self->s3->host;
    my $uri = "$protocol://$host/$path";
    
    $uri = URI->new($uri);
    $uri->query_param(Expires => $expires);

    return $signer->signed_url(HTTP::Request->new(GET => $uri));
}


# generates an HTTP::Headers objects given one hash that represents http
# headers to set and another hash that represents an object's metadata.
sub _merge_meta {
    my ( $self, $headers, $metadata ) = @_;
    $headers  ||= {};
    $metadata ||= {};

    my $http_header = HTTP::Headers->new;
    while ( my ( $k, $v ) = each %$headers ) {
        $http_header->header( $k => $v );
    }
    while ( my ( $k, $v ) = each %$metadata ) {
        $http_header->header( "$METADATA_PREFIX$k" => $v );
    }

    return $http_header;
}

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  my $http_request = Net::Amazon::S3::HTTPRequest->new(
    s3      => $self->s3,
    method  => 'PUT',
    path    => $self->bucket . '/',
    headers => $headers,
    content => $content,
  )->http_request;

=head1 DESCRIPTION

This module creates an HTTP::Request object that is signed
appropriately for Amazon S3.

=head1 METHODS

=head2 http_request

This method creates, signs and returns a HTTP::Request object.

=head2 query_string_authentication_uri

This method creates, signs and returns a query string authentication
URI.
