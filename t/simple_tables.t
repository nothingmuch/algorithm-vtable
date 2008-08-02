#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use ok 'Algorithm::VTable::Symbol';
use ok 'Algorithm::VTable::Container';
use ok 'Algorithm::VTable';

my $base = Algorithm::VTable::Container->new(
	symbols => [
		Algorithm::VTable::Symbol->new( name => "foo" ),
		Algorithm::VTable::Symbol->new( name => "bar" ),
	],
);

my $sub = Algorithm::VTable::Container->new(
	symbols => [
		@{ $base->symbols },
		Algorithm::VTable::Symbol->new( name => "gorch" ),
	],
);

my $override = Algorithm::VTable::Container->new(
	symbols => [
		$base->symbols->[1], # bar
		Algorithm::VTable::Symbol->new( name => "foo" ),
	],
);

my $rev_override = Algorithm::VTable::Container->new(
	symbols => [
		Algorithm::VTable::Symbol->new( name => "foo" ),
		$base->symbols->[1], # bar
	],
);

{
	my $t = Algorithm::VTable->new(
		containers => [ $base ],
	);

	isa_ok( $t, "Algorithm::VTable" );

	is_deeply( [ $t->symbol_name_index(qw(foo bar)) ], [ 0, 1 ], "symbol index" );

	is_deeply(
		$t->symbols,
		$base->symbols,
		"all vtable symbols",
	);

	is_deeply(
		$t->container_slots($base),
		{ foo => 0, bar => 1 },
		"container slots",
	);

	is_deeply(
		$t->container_table($base),
		[ 0, 1 ],
		"vtable for base",
	);
}

{
	my $t = Algorithm::VTable->new(
		containers => [ $base, $sub ],
	);

	isa_ok( $t, "Algorithm::VTable" );

	is_deeply( [ $t->symbol_name_index(qw(foo bar gorch)) ], [ 0, 1, 2 ], "symbol index" );

	is_deeply(
		$t->symbols,
		$sub->symbols,
		"all vtable symbols",
	);

	is_deeply(
		$t->container_slots($base),
		{ foo => 0, bar => 1 },
		"container slots",
	);

	is_deeply(
		$t->container_table($base),
		[ 0, 1 ],
		"vtable for base",
	);

	is_deeply(
		$t->container_slots($sub),
		{ foo => 0, bar => 1, gorch => 2 },
		"container slots",
	);

	is_deeply(
		$t->container_table($sub),
		[ 0, 1, 2 ],
		"vtable for sub",
	);
}

{
	my $t = Algorithm::VTable->new(
		containers => [ $base, $override ],
	);

	isa_ok( $t, "Algorithm::VTable" );

	is_deeply( [ $t->symbol_name_index(qw(foo bar)) ], [ 0, 1 ], "symbol index" );

	is_deeply(
		$t->symbols,
		[ @{ $base->symbols }, $override->symbols->[1] ],
		"all vtable symbols",
	);

	is_deeply(
		$t->container_table($base),
		[ 0, 1 ],
		"vtable for base",
	);

	is_deeply(
		$t->container_slots($override),
		{ foo => 1, bar => 0 },
		"container slots",
	);

	is_deeply(
		$t->container_table($override),
		[ 1, 0 ],
		"vtable for override",
	);
}

{
	my $t = Algorithm::VTable->new(
		containers => [ $base, $sub, $override ],
	);

	isa_ok( $t, "Algorithm::VTable" );

	is_deeply( [ $t->symbol_name_index(qw(foo bar gorch)) ], [ 0, 1, 2 ], "symbol index" );

	is_deeply(
		$t->container_table($base),
		[ 0, 1 ],
		"vtable for base",
	);

	is_deeply(
		$t->container_table($sub),
		[ 0, 1, 2 ],
		"vtable for sub",
	);

	is_deeply(
		$t->container_table($override),
		[ 1, 0 ],
		"vtable for override",
	);
}

{
	my $t = Algorithm::VTable->new(
		containers => [ $base, $sub, $rev_override ],
	);

	isa_ok( $t, "Algorithm::VTable" );

	is_deeply( [ $t->symbol_name_index(qw(foo bar gorch)) ], [ 0, 1, 2 ], "symbol index" );

	is_deeply(
		$t->container_table($base),
		[ 0, 1 ],
		"vtable for base",
	);

	is_deeply(
		$t->container_table($sub),
		[ 0, 1, 2 ],
		"vtable for sub",
	);

	is_deeply(
		$t->container_table($rev_override),
		[ 0, 1 ],
		"vtable for alternate order override",
	);
}


{
	my $t = Algorithm::VTable->new(
		vtable_meta_symbol => "first",
		containers => [ $base, $sub ],
	);

	isa_ok( $t, "Algorithm::VTable" );

	is( $t->vtable_slot, 0, "vtable slot" );

	is_deeply( [ $t->symbol_name_index(qw(foo bar gorch)) ], [ 0, 1, 2 ], "symbol index" );

	is_deeply(
		$t->symbols,
		$sub->symbols,
		"all vtable symbols",
	);

	is_deeply(
		$t->container_slots($base),
		{ foo => 1, bar => 2 },
		"container slots",
	);

	is_deeply(
		$t->container_table($base),
		[ 1, 2 ],
		"vtable for base",
	);

	is_deeply(
		$t->container_slots($sub),
		{ foo => 1, bar => 2, gorch => 3 },
		"container slots",
	);

	is_deeply(
		$t->container_table($sub),
		[ 1, 2, 3 ],
		"vtable for sub",
	);
}
