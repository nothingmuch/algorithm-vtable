#!/usr/bin/perl

package Algorithm::VTable::Container;
use Moose;

use Algorithm::VTable::Symbol;

use namespace::clean -except => 'meta';

with qw(Algorithm::VTable::ID);

sub new_from_class {
	my ( $class, $source, @args ) = @_;

	my $meta = (ref $source ? $source : Class::MOP::Class->initialize($source));

	$class->new(
		id      => $meta->name,
		class   => $meta,
		vtable_meta_symbol => "first",
		symbols => [
			map { Algorithm::VTable::Symbol->new_from_attribute($meta, $_) }
				$meta->compute_all_applicable_attributes,
		],
		@args,
	);
}

has class => (
	isa => "Class::MOP::Class",
	is  => "ro",
	predicate => "has_class",
);

has symbols => (
	isa => "ArrayRef[Algorithm::VTable::Symbol]",
	is  => "ro",
	required => 1,
);

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__

=pod

=head1 NAME

Algorithm::VTable::Container - 

=head1 SYNOPSIS

	use Algorithm::VTable::Container;

=head1 DESCRIPTION

=cut


