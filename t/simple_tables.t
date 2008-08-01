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
		@{ $base->symbols },
		Algorithm::VTable::Symbol->new( name => "foo" ),
	],
);

{
	my $t = Algorithm::VTable->new(
		containers => [ $base ],
	);

	isa_ok( $t, "Algorithm::VTable" );

	is_deeply(
		$t->symbols,
		$base->symbols,
		"all vtable symbols",
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

	is_deeply(
		$t->symbols,
		$sub->symbols,
		"all vtable symbols",
	);

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
}

{
	my $t = Algorithm::VTable->new(
		containers => [ $base, $override ],
	);

	isa_ok( $t, "Algorithm::VTable" );

	is_deeply(
		$t->symbols,
		$override->symbols,
		"all vtable symbols",
	);

	is_deeply(
		$t->container_table($base),
		[ 0, 1 ],
		"vtable for base",
	);

	is_deeply(
		$t->container_table($override),
		[ 2, 1 ],
		"vtable for override",
	);
}
