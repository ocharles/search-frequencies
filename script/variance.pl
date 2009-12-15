use strict;
use FindBin '$Bin';
use lib "$Bin/../lib";

use DateTime::Format::SQLite;
use DateTime::Format::Strptime;
use DBI;
use SQL::Abstract;
use Statistics::Descriptive;
my $st = Statistics::Descriptive::Full->new;

use SearchFrequencies::Test;
use SearchFrequencies::Test::Query;

my $dbh = DBI->connect("dbi:SQLite:dbname=$Bin/../search_results.db") or die 'Could not connect to database';
my $sql = SQL::Abstract->new;

my $step = shift @ARGV;
my $prov = shift @ARGV;
my $term = join ' ', @ARGV;
my ($q, @b) = $sql->select('search_results', '*', { provider => $prov, query => '"' . $term . '"' },
                       { -asc => 'date' });
print "$q\n";
my $sth = $dbh->prepare($q);
$sth->execute(@b);

open(my $var, '>', "$Bin/../csv/$term $step $prov variance.csv");

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

    if ($this_time - $last_sample > $step) {
        print $var "$days," . $groups->{ $result->query}->devz . "\n";
        $groups->{ $result->query }->clear_queries;
        $last_sample = $this_time;
        $days++;
    }
}

close($var);


