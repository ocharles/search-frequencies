use strict;
use warnings;
use Data::Entropy::Algorithms qw(shuffle);

my (@idiomatic, @words);

# Parse out all the idiomatic expressions that look interesting
open(my $fh, '<', 'idioms.c7');
while(my $line = <$fh>) {
    chomp $line;
    my ($interesting) = $line =~ /(.*)\s{2,}.*$/;
    next unless $interesting;
    $interesting =~ s/_\w+\b//g;
    next unless $interesting =~ /^[a-z\s]+$/;
    $interesting =~ s/\s+$//g;
    push @idiomatic, $interesting;
}
close($fh);

# Parse the top 1000 single words
open($fh, '<', '1_2_all_freq.txt');
my $i = 0;
while ($i < 1000) {
    my $line = <$fh>;
    chomp $line;
    $line =~ s/^\s+(.*)/$1/;
    my ($word, $type, $freq) = split /\s+/, $line;
    next unless $word =~ /^[A-Za-z]+$/;
    push @words, $word;
    $i++;
}
close($fh);

open ($fh, '>', 'queries.txt');
# Take 2000 idiomatic expressions
my @shuffled = shuffle(@idiomatic);
for my $i (1..2000) {
    print $fh $shuffled[$i] . "\n";
}

# Take all the single words
for my $word (@words) {
    print $fh "$word\n";
}
close($fh);
