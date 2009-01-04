package Kotoba;

use strict;
use warnings;

# Needed on the hosting machine. Can’t use Apache’s
# SetEnv, as the hoster does not support it.
use lib '/home/kotobacz/local/lib/perl/5.8.8';
use lib '/home/kotobacz/local/share/perl/5.8.8';

use Catalyst::Runtime '5.70';
use parent qw/Catalyst/;
use Catalyst qw/ConfigLoader
                Static::Simple
                Unicode::Encoding
                Email/;

Kotoba->setup();

1;
