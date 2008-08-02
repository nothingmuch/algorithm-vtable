#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use ok 'Algorithm::VTable::Symbol';
use ok 'Algorithm::VTable::Container';
use ok 'Algorithm::VTable';

my $base1 = Algorithm::VTable::Container->new(
	symbols => [
		Algorithm::VTable::Symbol->new( name => "foo" ),
		Algorithm::VTable::Symbol->new( name => "bar" ),
	],
);

my $base2 = Algorithm::VTable::Container->new(
	symbols => [
		Algorithm::VTable::Symbol->new( name => "gorch" ),
		Algorithm::VTable::Symbol->new( name => "baz" ),
	],
);

my $sub = Algorithm::VTable::Container->new(
	symbols => [ map { @{ $_->symbols } } $base1, $base2 ],
);

{
	my $t = Algorithm::VTable->new(
		containers => [ $base1, $base2 ],
	);

	isa_ok( $t, "Algorithm::VTable" );

	is_deeply( [ $t->symbol_name_index(qw(foo bar gorch baz)) ], [ 0 .. 3 ], "symbol index" );

	is_deeply(
		$t->symbols,
		[ @{ $base1->symbols }, @{ $base2->symbols } ],
		"all vtable symbols",
	);

	is_deeply(
		$t->container_slots($base1),
		{ foo => 0, bar => 1 },
		"container slots",
	);

	is_deeply(
		$t->container_table($base1),
		[ 0, 1 ],
		"vtable for base1",
	);

	is_deeply(
		$t->container_slots($base2),
		{ gorch => 0, baz => 1 },
		"container slots",
	);

	is_deeply(
		$t->container_table($base2),
		[ undef, undef, 0, 1 ], # FIXME suboptimal vtable, we can statically renumber because e.g. 'gorch' and 'foo' are never shared, see next test though, symbol_name_index could be parametrized over a class to apply to it and all its decendents
		"vtable for base2",
	);
}

{
	my $t = Algorithm::VTable->new(
		containers => [ $base1, $base2, $sub ],
	);

	isa_ok( $t, "Algorithm::VTable" );

	is_deeply( [ $t->symbol_name_index(qw(foo bar gorch baz)) ], [ 0 .. 3 ], "symbol index" );

	is_deeply(
		$t->symbols,
		[ @{ $base1->symbols }, @{ $base2->symbols } ],
		"all vtable symbols",
	);

	is_deeply(
		$t->container_slots($base1),
		{ foo => 0, bar => 1 },
		"container slots",
	);

	is_deeply(
		$t->container_slots($base2),
		{ gorch => 0, baz => 1 },
		"container slots",
	);

	is_deeply(
		$t->container_slots($sub),
		{ foo => 0, bar => 1, gorch => 2, baz => 3 },
		"container slots",
	);

	is_deeply(
		$t->container_table($sub),
		[ 0 .. 3 ],
		"vtable for sub",
	);
}
