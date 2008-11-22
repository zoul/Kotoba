#!/usr/bin/perl

use strict;
use warnings;

# 1..3
my $bgrindex = int(rand(3)) + 1;

print "Content-type: text/css\n\n";
print <<"EOF";
body
{
    background: url(data/bgr$bgrindex.gif);
}
EOF
