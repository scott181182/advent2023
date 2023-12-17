#!/usr/bin/perl
package part1;

use strict;
use warnings;
use List::Util qw(reduce);



my $filename = $ARGV[0];
open(FILE, $filename) or die("Could not open file '$filename'");

my $total = 0;
foreach my $line (<FILE>) {
    if($line =~ /^Card\s+(\d+):\s+([\d ]+)\s+\|\s+([\d ]+)\n?$/) {
        my $card_no = $1;
        my %winning_set = map { $_ => 1 } split(/\s+/, $2);

        my $card_total = reduce { exists($winning_set{$b}) ? $a + 1 : $a } 0, split(/\s+/, $3);
        # print "Card #$card_no -> $card_total\n";
        if($card_total > 0) {
            $total += 2 ** ($card_total - 1);
        }
    } else {
        print "Unmatched Line: '$line'"
    }
}
print "Part 1 Total: $total\n";
