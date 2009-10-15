use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use SearchFrequencies;

use DBI;
use DateTime::Format::SQLite;

my $dbh =
  DBI->connect("dbi:SQLite:dbname=$FindBin::Bin/../search_results.db", "", "");
my $insert =
  "INSERT INTO search_results (query, date, estimated_count, provider) VALUES (?, ?, ?, ?)";
my $sth = $dbh->prepare($insert);

my @words;

open(my $term_file, '<', "$FindBin::Bin/queries.txt");
while (my $line = <$term_file>) {
    chomp $line;
    push @words, $line;
}
close($term_file);

my $search = SearchFrequencies->new;
for my $word (@words) {
    $word = q{"} . $word . q{"};
    my $results = $search->search($word);
    while(my ($provider, $count) = each %$results) {
        next unless $count;
        $sth->execute(
            $word,
            DateTime::Format::SQLite->format_datetime(DateTime->now()),
            $count,
            $provider
        );
    }
}
