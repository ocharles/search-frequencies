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

my $term = join ' ', @ARGV;
my ($q, @b) = $sql->select('search_results', '*', { provider => 'Google' },
                       { -asc => 'date' });
print "$q\n";
my $sth = $dbh->prepare($q);
$sth->execute(@b);

open(my $var, '>', "$Bin/../csv/$term variance.csv");

my $groups = {};
my $first_q;

while (my $row = $sth->fetchrow_hashref) {
    my $result = SearchFrequencies::Test::Query->new($row);

    if ($first_q && $result->query eq $first_q) {
        my $st = Statistics::Descriptive::Full->new;
        $st->add_data(map { $_->dev_factor } values %$groups);
        print $var $st->standard_deviation . "\n";
    }

    $first_q ||= $result->query;
    $groups->{ $result->query} ||= SearchFrequencies::Test->new;
    $groups->{ $result->query}->add_query($result);
}

close($var);
