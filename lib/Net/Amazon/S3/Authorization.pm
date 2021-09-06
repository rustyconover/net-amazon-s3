package Net::Amazon::S3::Authorization;

use Moose 0.85;

# ABSTRACT: Authorization context base class

sub aws_access_key_id {
}

sub aws_secret_access_key {
}

sub aws_session_token {
}

sub authorization_headers {
}

1;

__END__

=pod

=head1 DESCRIPTION

Authorization context provides an access to authorization information

