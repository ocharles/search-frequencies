use strict;
use warnings;
use Data::Entropy::Algorithms qw(shuffle);

my @possible;

open(my $fh, '<', 'idioms.c7');
while(my $line = <$fh>) {
    chomp $line;
    my ($interesting) = $line =~ /(.*)\s{2,}.*$/;
    next unless $interesting;
    $interesting =~ s/_\w+\b//g;
    next unless $interesting =~ /^[a-z\s]+$/;
    $interesting =~ s/\s+$//g;
    push @possible, $interesting;
}
close($fh);

open ($fh, '>', 'queries.txt');
my @shuffled = shuffle(@possible);
for my $i (1..2000) {
    print $fh $shuffled[$i] . "\n";
}
close($fh);
