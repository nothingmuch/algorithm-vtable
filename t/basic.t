#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use Scalar::Util qw(refaddr);

use ok 'Algorithm::VTable::Symbol';
use ok 'Algorithm::VTable::Container';

{
	my $symbol = Algorithm::VTable::Symbol->new( name => "foo", id => "bar" );

	isa_ok( $symbol, "Algorithm::VTable::Symbol" );
	is( $symbol->name, "foo", "name" );
	is( $symbol->id, "bar", "id" );
}

{
	my $symbol = Algorithm::VTable::Symbol->new( name => "foo" );

	isa_ok( $symbol, "Algorithm::VTable::Symbol" );
	is( $symbol->name, "foo", "name" );
	is( $symbol->id, refaddr($symbol), "default ID" );
}


{
	my @symbols = map { Algorithm::VTable::Symbol->new( name => $_ ) } qw(foo bar);

	my $container = Algorithm::VTable::Container->new( symbols => \@symbols );

	isa_ok( $container, "Algorithm::VTable::Container" );

	is( $container->id, refaddr($container), "default ID" );

	is_deeply( $container->symbols, \@symbols, "symbols" );
}
