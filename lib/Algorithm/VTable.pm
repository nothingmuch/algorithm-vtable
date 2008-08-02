#!/usr/bin/perl

package Algorithm::VTable;
use Moose;

use Algorithm::VTable::Symbol;
use Algorithm::VTable::Container;

use namespace::clean -except => 'meta';

has containers => (
	isa => "ArrayRef[Algorithm::VTable::Container]",
	is  => "ro",
	required => 1,
);

has symbols => (
	isa => "ArrayRef[Algorithm::VTable::Symbol]",
	is  => "ro",
	lazy_build => 1,
);

# computed attrs:

has _container_slots => (
	isa => "HashRef[HashRef[Int]]",
	is  => "ro",
	init_arg => undef,
	default => sub { {} },
);

has _container_tables => (
	isa => "HashRef[ArrayRef[Int]]",
	is  => "ro",
	init_arg => undef,
	default => sub { {} },
);

sub container_slots {
	my ( $self, $container ) = @_;
	$self->_container_slots->{$container->id} ||= $self->compute_container_slots($container);
}

sub compute_container_slots {
	my ( $self, $container ) = @_;

	my $i;

	return {
		map { $_->name => $i++ }
			@{ $container->symbols }
	};
}

sub container_table {
	my ( $self, $container ) = @_;
	$self->_container_tables->{$container->id} ||= $self->compute_container_table($container);
}

sub compute_container_table {
	my ( $self, $container ) = @_;

	my @names   = map { $_->name } @{ $container->symbols };
	my @indexes = @{ $self->symbol_name_indexes }{ @names };
	my @slots   = @{ $self->container_slots($container) }{@names};

	my @table;
	@table[@indexes] = @slots;

	return \@table;

	# FIXME scheck if $name is unique to container
	# if it's unique it's just an index
	# if it's shared then wee try to match the index up with other usages
	# if we can then the table can be omitted
}

sub symbol_name_index {
	my ( $self, @symbols ) = @_;
	
	if ( @symbols == 1 ) {
		return $self->symbol_name_indexes->[$symbols[0]];
	} else {
		return @{ $self->symbol_name_indexes }{@symbols};
	}
}

# FIXME partition containers based on symbol sharing, to isolate separate
# hierarchies

# auxillary computed attrs
has containers_by_id => (
	isa => "HashRef[Algorithm::VTable::Container]",
	is  => "ro",
	init_arg => undef,
	lazy_build => 1,
);

has symbols_by_id => (
	isa => "HashRef[Algorithm::VTable::Symbol]",
	is  => "ro",
	init_arg => undef,
	lazy_build => 1,
);

has symbols_by_name => (
	isa => "HashRef[Algorithm::VTable::Symbol]",
	is  => "ro",
	init_arg => undef,
	lazy_build => 1,
);

has symbol_index_names => (
	isa => "ArrayRef[Str]",
	is  => "ro",
	init_arg => undef,
	lazy_build => 1,
);

has symbol_name_indexes => (
	isa => "HashRef[Int]",
	is  => "ro",
	init_arg => undef,
	lazy_build => 1,
);


# this is a fallback, the user can request to only compute a certain set of
# symbols or to specify a certain order
sub _build_symbols {
	my $self = shift;

	my %seen;

	# FIXME attempt to create an idealized order?
	return [
		grep { not $seen{$_->id}++ }
			map { @{ $_->symbols } }
				@{ $self->containers }
	];
}


# these methods compute the various intermediate values

sub _build_containers_by_id {
	my $self = shift;

	return {
		map { $_->id => $_ }
			@{ $self->containers }
	}
}

sub _build_symbols_by_id {
	my $self = shift;

	return {
		map { $_->id => $_ }
			@{ $self->symbols }
	}
}

sub _build_symbols_by_name {
	my $self = shift;

	return { map { $_->name => $_ } @{ $self->symbols } };
}

sub _build_symbol_index_names {
	my $self = shift;

	my %seen;

	return [
		grep { not $seen{$_}++ }
			map { $_->name } @{ $self->symbols }
	];
}

sub _build_symbol_name_indexes {
	my $self = shift;

	my $i;

	return {
		map { $_ => $i++ }
			@{ $self->symbol_index_names }
	};
}

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__

=pod

=head1 NAME

Algorithm::VTable - 

=head1 SYNOPSIS

	use Algorithm::VTable;

=head1 DESCRIPTION

=cut


