#!perl

use strict;

use Test::More;
use Test::Warnings qw[ :no_end_test had_no_warnings ];
use Test::LoadAllModules;

plan tests => 2;

subtest 'use_ok' => sub {
    all_uses_ok(
        search_path => 'Net::Amazon::S3',
        except => [qw/ /],
    )
};

had_no_warnings;
