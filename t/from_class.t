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
				reverse( Algorithm::VTable::Symbol->meta->compute_all_applicable_attributes ),
				reverse( Algorithm::VTable::Container->meta->compute_all_applicable_attributes ),
	},
	"name index per attr",
);

is_deeply( [ sort keys %{ $t->containers_by_id } ], [ sort qw(Algorithm::VTable::Symbol Algorithm::VTable::Container Moose::Object) ], "container IDs" );

my ( $sym, $con ) = @{ $t->containers_by_id }{qw(Algorithm::VTable::Symbol Algorithm::VTable::Container)};

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

{
	package Subclass;
	use Moose;

	extends qw(Algorithm::VTable::Symbol);

	has foo => ( is => "ro");
}

{
	my $t2 = $t->append_classes(qw(Subclass));

	isa_ok( $t2, "Algorithm::VTable", "clone");

	is_deeply( [ sort keys %{ $t2->containers_by_id } ], [ sort qw(Subclass Algorithm::VTable::Symbol Algorithm::VTable::Container Moose::Object) ], "container IDs" );

	{
		my $table = $t2->container_table($sym);

		is( $table->[ $t2->symbol_name_index("symbols") ], undef, "'symbols' symbol doesn't have a slot" );
		ok( $table->[ $t2->symbol_name_index("name") ], "'name' symbol has slot" );
		is( $table->[ $t2->symbol_name_index("name") ], $t->container_table($sym)->[ $t->symbol_name_index("name") ], "'name' slot is unchanged" );
	}

	{
		my $table = $t2->container_table($con);

		is( $table->[ $t2->symbol_name_index("name") ], undef, "'name' symbol doesn't have a slot" );
		ok( $table->[ $t2->symbol_name_index("symbols") ], "'symbols' symbol has slot" );

		is( $table->[ $t2->symbol_name_index("symbols") ], $t->container_table($con)->[ $t->symbol_name_index("symbols") ], "'symbols' slot is unchanged" );
	}

	{
		my $table = $t2->container_table($t2->containers_by_id->{"Subclass"});

		is( $table->[ $t2->symbol_name_index("symbols") ], undef, "'symbols' symbol doesn't have a slot" );
		ok( $table->[ $t2->symbol_name_index("name") ], "'name' symbol has slot" );
		ok( $table->[ $t2->symbol_name_index("foo") ], "'name' symbol has slot" );
		is( $table->[ $t2->symbol_name_index("name") ], $t->container_table($sym)->[ $t->symbol_name_index("name") ], "'name' slot is unchanged from superclass" );
	}
}
