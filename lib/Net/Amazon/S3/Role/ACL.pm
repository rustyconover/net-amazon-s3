package Net::Amazon::S3::Role::ACL;
# ABSTRACT: ACL specification

use Moose::Role;
use Moose::Util::TypeConstraints;

use Carp ();

use Net::Amazon::S3::ACL::Set;
use Net::Amazon::S3::ACL::Canned;
use Net::Amazon::S3::Constraint::ACL::Canned;

has acl => (
	is          => 'ro',
	isa         => union ([
		'Net::Amazon::S3::ACL::Set',
		'Net::Amazon::S3::ACL::Canned',
	]),
	required    => 0,
	coerce      => 1,
);

around BUILDARGS => sub {
	my ($orig, $class) = (shift, shift);
	my $args = $class->$orig (@_);

	if (exists $args->{acl_short}) {
		my $acl_short = delete $args->{acl_short};

		Carp::carp "'acl_short' parameter is ignored when 'acl' specified"
			if exists $args->{acl};

		$args->{acl} = $acl_short
			unless exists $args->{acl};
	}

	delete $args->{acl} unless defined $args->{acl};

	return $args;
};

1;
