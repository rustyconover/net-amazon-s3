package Net::Amazon::S3::Utils;
# ABSTRACT: misc utils

sub parse_arguments {
	my ($self, $arguments, $positional, $aliases) = @_;
	my %args;
	$aliases = {} unless $aliases;

	push @$arguments, %{ pop @$arguments }
		if @$arguments && Ref::Util::is_plain_hashref ($arguments->[-1]);

	my %positional = map +($_ => 1), grep ! exists $args{$_}, @$positional;
	my $positional_count = scalar keys %positional;
	while (@$arguments > 1 && @$arguments > $positional_count) {
		my ($name, $value) = splice @$arguments, -2, 2;

		next if exists $args{$name};

		$args{$name} = $value;

		$name = $aliases->{$name} if exists $aliases->{$name};

		if (exists $positional{$name}) {
			$positional_count--;
			delete $positional{$name};
		}
	}

	#die "Odd number of named arguments"
	#	if @$arguments != $positional_count;

	for my $key (keys %$aliases) {
		next unless exists $args{$key};
		my $value = delete $args{$key};
		my $alias_for = $aliases->{$key};
		$args{$alias_for} = $value unless exists $args{$alias_for};
	}

	for my $name (@$positional) {
		next if exists $args{$name};
		$args{$name} = shift @$arguments;
	}

	return %args;
}

sub parse_arguments_with_bucket {
	my ($self, $arguments) = @_;

	return $self->parse_arguments ($arguments, [qw[ bucket ]], { name => 'bucket' });
}

sub parse_arguments_with_bucket_and_object {
	my ($self, $arguments) = @_;

	return $self->parse_arguments ($arguments, [qw[ bucket key ]], { name => 'bucket' });
}

sub parse_arguments_with_object {
	my ($self, $arguments) = @_;

	return $self->parse_arguments ($arguments, [qw[ key ]], { name => 'bucket' });
}

1;

