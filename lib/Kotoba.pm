package Kotoba;

use strict;
use warnings;
use lib glob '~/perl5/lib/perl5/';

use Catalyst::Runtime '5.70';
use parent qw/Catalyst/;
use Catalyst qw/ConfigLoader
                Static::Simple
                Unicode::Encoding
                Email/;

Kotoba->setup();

1;
