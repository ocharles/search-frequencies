use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use SearchFrequencies;

my $search = SearchFrequencies->new;
use Data::Dumper;
print Dumper $search->search('"until"');
