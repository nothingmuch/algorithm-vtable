#!/usr/bin/perl

package Algorithm::VTable::Symbol;
use Moose;

use namespace::clean -except => 'meta';

with qw(Algorithm::VTable::ID);

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


