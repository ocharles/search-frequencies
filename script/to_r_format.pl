use strict;
use warnings;
use DateTime;
use DateTime::Format::Strptime;
use DateTime::Format::SQLite;
use DBI;
use FindBin;
use List::Util qw( sum );

my $dbh =
  DBI->connect("dbi:SQLite:dbname=$FindBin::Bin/../search_results.db", "", "");

my $all_idiomatic = $dbh->selectall_arrayref(
    "SELECT * FROM search_results WHERE query = '\"in the sense of\"' ORDER BY date",
    { Slice => {} },
);

my $format = DateTime::Format::Strptime->new(pattern => '%Y/%m/%d,%H:%M');

mkdir "$FindBin::Bin/../r";
open(my $all_idiomatic_google, '>', "$FindBin::Bin/../r/idiomatic_google.csv");
open(my $all_idiomatic_bing, '>', "$FindBin::Bin/../r/idiomatic_bing.csv");
open(my $all_idiomatic_yahoo, '>', "$FindBin::Bin/../r/idiomatic_yahoo.csv");
my ($first_date, $last_date);
my ($google, $bing, $yahoo);
for my $search (@$all_idiomatic) {
    my $date = DateTime::Format::SQLite->parse_datetime($search->{date});

    if ($search->{provider} eq 'Google') {
        printf $all_idiomatic_google $format->format_datetime($date) . ',' . $search->{estimated_count} . "\n";
    }

    if ($search->{provider} eq 'Bing') {
        printf $all_idiomatic_bing $format->format_datetime($date) . ',' . $search->{estimated_count} . "\n";
    }

    if ($search->{provider} eq 'Yahoo!') {
        printf $all_idiomatic_yahoo $format->format_datetime($date) . ',' . $search->{estimated_count} . "\n";
    }
}
close($all_idiomatic_yahoo);
close($all_idiomatic_bing);
close($all_idiomatic_google);
