#!/usr/bin/perl

package Algorithm::VTable::ID;
use Moose::Role;

use Scalar::Util qw(refaddr);

use namespace::clean -except => 'meta';

has id => (
	isa => "Str",
	is  => "ro",
	lazy => 1,
	default => sub { refaddr($_[0]) },
);

__PACKAGE__

__END__

=pod

=head1 NAME

Algorithm::VTable::ID - 

=head1 SYNOPSIS

	with qw(Algorithm::VTable::ID);

=head1 DESCRIPTION

=cut


