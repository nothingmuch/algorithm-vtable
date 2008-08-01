#!/usr/bin/perl

package Algorithm::VTable::Container;
use Moose;

use Algorithm::VTable::Symbol;

use namespace::clean -except => 'meta';

with qw(Algorithm::VTable::ID);

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


