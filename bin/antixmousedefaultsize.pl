#!/usr/bin/perl

#---------- Variables ----------#

$home=`echo \$HOME`;
chomp($home);
$filepath="$home/\.Xdefaults";

$entryregex="Xcursor.*";

#---------- Begin Script ----------#

$lines=`cat $filepath`;

# re-add entry by removing the comment
$lines =~ s{#($entryregex)}{$1};

# remove entry by commenting it out
$lines =~ s{($entryregex)}{#$1};

open (SCRIPT, ">$filepath");

print SCRIPT $lines;
close (SCRIPT);
