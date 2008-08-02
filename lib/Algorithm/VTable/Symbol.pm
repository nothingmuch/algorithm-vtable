#!/usr/bin/perl

package Algorithm::VTable::Symbol;
use Moose;

use namespace::clean -except => 'meta';

with qw(Algorithm::VTable::ID);

sub new_from_attribute {
	my ( $class, $meta, $attr, @args ) = @_;

	my $name = $attr->name;

	$class->new(
		attribute => $attr,
		name => $name,
		id   => $name, # FIXME broken for roles, should be optional: join("::", $attr->associated_metaclass->name, $name ),
	);
}

has attribute => (
	isa => "Class::MOP::Attribute",
	is  => "ro",
	predicate => "has_attribute",
);

has name => (
	isa => "Str",
	is  => "ro",
	required => 1,
);

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__

=pod

=head1 NAME

Algorithm::VTable::Symbol - 

=head1 SYNOPSIS

	use Algorithm::VTable::Symbol;

=head1 DESCRIPTION

=cut


