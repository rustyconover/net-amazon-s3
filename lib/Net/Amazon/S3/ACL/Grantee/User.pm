package Net::Amazon::S3::ACL::Grantee::User;
# ABSTRACT: Represents user reference for ACL

use Moose;

extends 'Net::Amazon::S3::ACL::Grantee';

has id => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

around BUILDARGS => sub {
	my ($orig, $class) = (shift, shift);
	unshift @_, 'id' if @_ == 1 && ! ref $_[0];

	return $class->$orig (@_);
};

sub format_for_header {
	my ($self) = @_;

	return "id=\"${\ $self->id }\"";
}

1;

__END__

=encoding utf8

=head1 SYNOPSIS

	use Net::Amazon::S3::ACL::Grantee::User;

	my $user = Net::Amazon::S3::ACL::Grantee::User->new (123);
	my $user = Net::Amazon::S3::ACL::Grantee::User->new (id => 123);

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENSE

This module is part of L<Net::Amazon::S3>.

=cut

