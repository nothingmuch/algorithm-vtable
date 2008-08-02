#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use ok 'Algorithm::VTable::Symbol';
use ok 'Algorithm::VTable::Container';
use ok 'Algorithm::VTable';

my $t = Algorithm::VTable->new_from_classes(
	classes => [ qw(Algorithm::VTable::Symbol Algorithm::VTable::Container ) ],
);

my ( $i, %seen );

is_deeply(
	$t->symbol_name_indexes,
	{ map { $_ => $i++ }
		grep { not $seen{$_}++ }
			map { $_->name }
				Algorithm::VTable::Symbol->meta->compute_all_applicable_attributes,
				Algorithm::VTable::Container->meta->compute_all_applicable_attributes,
	},
	"name index per attr",
);

my %containers = map { $_->class->name => $_ } @{ $t->containers };

my $sym = $containers{"Algorithm::VTable::Symbol"};
my $con = $containers{"Algorithm::VTable::Container"};

{
	my $table = $t->container_table($sym);

	is( $table->[ $t->symbol_name_index("symbols") ], undef, "'symbols' symbol doesn't have a slot" );
	ok( $table->[ $t->symbol_name_index("name") ], "'name' symbol has slot" );
}

{
	my $table = $t->container_table($con);

	is( $table->[ $t->symbol_name_index("name") ], undef, "'name' symbol doesn't have a slot" );
	ok( $table->[ $t->symbol_name_index("symbols") ], "'symbols' symbol has slot" );
}

