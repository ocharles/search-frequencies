use strict;
use FindBin '$Bin';
use lib "$Bin/../lib";

use DateTime::Format::SQLite;
use DateTime::Format::Strptime;
use DBI;
use List::Util qw( sum );
use SQL::Abstract;
use Statistics::Descriptive;
my $st = Statistics::Descriptive::Full->new;

use SearchFrequencies::Test;
use SearchFrequencies::Test::Query;

my $dbh = DBI->connect("dbi:SQLite:dbname=$Bin/../search_results.db") or die 'Could not connect to database';
my $sql = SQL::Abstract->new;

my $step = shift @ARGV;
my $prov = shift @ARGV;
my ($q, @b) = $sql->select('search_results', '*', { provider => $prov },
                       { -asc => 'date' });
print "$q\n";
my $sth = $dbh->prepare($q);
$sth->execute(@b);

open(my $var, '>', "$Bin/../csv/$prov $step all.csv");

my $groups = {};
my $last_sample;
my $days;

print $var "days,stdev\n";

while (my $row = $sth->fetchrow_hashref) {
    my $result = SearchFrequencies::Test::Query->new($row);
    $groups->{ $result->query} ||= SearchFrequencies::Test->new;
    $groups->{ $result->query}->add_query($result);

    my $this_time = $result->date->epoch;
    $last_sample ||= $this_time;

    my @vals = values %$groups;
    if ($this_time - $last_sample > $step && @vals) {
        print $var "$days," . ((sum map { $_->dev_factor } @vals) / @vals) . "\n";
        $_->clear_queries for values %$groups;
        $last_sample = $this_time;
        $days++;
    }
}

close($var);


