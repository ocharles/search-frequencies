use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use SearchFrequencies::Search::Google;

use DBI;
use DateTime::Format::SQLite;

my $dbh =
  DBI->connect("dbi:SQLite:dbname=$FindBin::Bin/../search_results.db", "", "");
my $insert =
  "INSERT INTO search_results (query, date, estimated_count) VALUES (?, ?, ?)";
my $sth = $dbh->prepare($insert);

my @words;

open(my $term_file, '<', "$FindBin::Bin/1_2_all_freq.txt");
my $line = <$term_file>;
my $i    = 0;
while ($i < 1000) {
    $line = <$term_file>;
    chomp $line;
    $line =~ s/^\s+(.*)/$1/;
    my ($word, $type, $freq) = split /\s+/, $line;
    next unless $word =~ /^[A-Za-z]+$/;
    push @words, $word;
    $i++;
}

my $search = SearchFrequencies::Search::Google->new;
for my $word (@words) {
    $sth->execute(
        $word,
        DateTime::Format::SQLite->format_datetime(DateTime->now()),
        $search->search($word)
    );
}
