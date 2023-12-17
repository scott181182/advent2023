#!/usr/bin/perl
package part1;

use strict;
use warnings;
use Data::Dumper qw(Dumper);
use List::Util qw(reduce);



my $filename = $ARGV[0];
open(FILE, $filename) or die("Could not open file '$filename'");

my %winning_map = ();
my $card_no = 0;
foreach my $line (<FILE>) {
    if($line =~ /^Card\s+(\d+):\s+([\d ]+)\s+\|\s+([\d ]+)\n?$/) {
        $card_no = $1;
        # Add one for the original copy we just got to.
        $winning_map{$card_no} = exists($winning_map{$card_no}) ? $winning_map{$card_no} + 1 : 1;

        my %winning_set = map { $_ => 1 } split(/\s+/, $2);

        # Number of matching numbers.
        my $card_total = reduce { exists($winning_set{$b}) ? $a + 1 : $a } 0, split(/\s+/, $3);

        foreach(($card_no + 1)..($card_no + $card_total)) {
            # Add copies to subsequent numbers.
            $winning_map{$_} = exists($winning_map{$_}) ? $winning_map{$_} + $winning_map{$card_no} : $winning_map{$card_no};
        }
    } else {
        print "Unmatched Line: '$line'"
    }
}

# Remove entries beyond the end of the scratchcard list.
while (exists($winning_map{$card_no + 1})) {
    $card_no += 1;
    delete $winning_map{$card_no};
}

# $Data::Dumper::Sortkeys = 1;
# print Dumper(\%winning_map);
my $total = reduce { $a + $b } values(%winning_map);
print "Part 2 Total: $total\n";
