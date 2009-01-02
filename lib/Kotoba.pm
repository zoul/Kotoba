package Kotoba;

use strict;
use warnings;

use lib '/home/kotobacz/.perl/lib/perl/5.8.8';
use lib '/home/kotobacz/.perl/share/perl/5.8.8';

use Catalyst::Runtime '5.70';
use parent qw/Catalyst/;
use Catalyst qw/ConfigLoader
                Static::Simple
                Unicode::Encoding/;

Kotoba->config(name => 'Kotoba', encoding => 'UTF-8');
Kotoba->setup();

1;
