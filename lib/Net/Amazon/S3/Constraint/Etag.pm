package Net::Amazon::S3::Constraint::Etag;
# Abstract: Moose constraint - Etag format

use Moose::Util::TypeConstraints;

type __PACKAGE__, where { $_ =~ /^[a-z0-9]{32}(?:-\d+)?$/ };

1;

