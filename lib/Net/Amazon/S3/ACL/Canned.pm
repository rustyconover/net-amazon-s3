package Net::Amazon::S3::ACL::Canned;
# ABSTRACT: Representation of canned ACL

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
use Moose::Util::TypeConstraints;

use Net::Amazon::S3::Constraint::ACL::Canned;

use Net::Amazon::S3::Constants;

class_type 'Net::Amazon::S3::ACL::Canned';

coerce 'Net::Amazon::S3::ACL::Canned'
	=> from 'Net::Amazon::S3::Constraint::ACL::Canned'
	=> via { Net::Amazon::S3::ACL::Canned->new ($_) }
	;

around BUILDARGS => sub {
	my ($orig, $class) = (shift, shift);

	return +{ canned_acl => $_[0] }
		if @_ == 1 && ! ref $_[0];

	return $class->$orig (@_);
};

has canned_acl => (
	is => 'ro',
	isa => 'Net::Amazon::S3::Constraint::ACL::Canned',
	required => 1,
);

sub build_headers {
	my ($self) = @_;

	return +(Net::Amazon::S3::Constants->HEADER_CANNED_ACL => $self->canned_acl);
}

sub PRIVATE                     { __PACKAGE__->new ('private') }
sub PUBLIC_READ                 { __PACKAGE__->new ('public-read') }
sub PUBLIC_READ_WRITE           { __PACKAGE__->new ('public-read-write') }
sub AWS_EXEC_READ               { __PACKAGE__->new ('aws-exec-read') }
sub AUTHENTICATED_READ          { __PACKAGE__->new ('authenticated-read') }
sub BUCKET_OWNER_READ           { __PACKAGE__->new ('bucket-owner-read') }
sub BUCKET_OWNER_FULL_CONTROL   { __PACKAGE__->new ('bucket-owner-full-control') }
sub LOG_DELIVERY_WRITE          { __PACKAGE__->new ('log-delivery-write') }

1;

__END__

=pod

=encoding utf8

=head1 SYNOPSIS

	my $acl = Net::Amazon::S3::ACL::Canned->PRIVATE;
	my $acl = Net::Amazon::S3::ACL::Canned->PUBLIC_READ;

=head1 DESCRIPTION

Class representes predefined Amazon S3 canned ACL.

=head1 FACTORY BUILDERS

=head2 PRIVATE

=head2 PUBLIC_READ

=head2 PUBLIC_READ_WRITE

=head2 AWS_EXEC_READ

=head2 AUTHENTICATED_READ

=head2 BUCKET_OWNER_READ

=head2 BUCKET_OWNER_FULL_CONTROL

=head2 LOG_DELIVER_WRITE

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENSE

This module is part of L<Net::Amazon::S3>.

=cut

