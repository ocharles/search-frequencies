use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use SearchFrequencies::Search::Bing;
use SearchFrequencies::Search;

use Data::Dumper;
print Dumper (@INC);


my $search = SearchFrequencies::Search::Bing->new;
$search->search('groove me');
