#!/usr/bin/perl -w

use strict;

use ExtUtils::MakeMaker;

WriteMakefile(
	NAME         => 'Algorithm::VTable',
	VERSION_FROM => 'lib/Algorithm/VTable.pm',
	INSTALLDIRS  => 'site',
	SIGN         => 1,
	PL_FILES     => { },
	PREREQ_PM    => {
		'Test::use::ok' => 0,
		'Moose' => 0.54,
		'namespace::clean' => 0.08,
	},
);

