#!/usr/bin/perl

#---------- Variables ----------#

$home=`echo \$HOME`;
chomp($home);
$filepath="$home/\.Xdefaults";

$entryregex="Xcursor.*";
$newentry="Xcursor.size: $ARGV[0]";

#---------- Begin Script ----------#

$lines=`cat $filepath`;

# re-add entry by removing the comment
$lines =~ s{#($entryregex)}{$1};

# replace entry with new one
$lines =~ s{$entryregex}{$newentry};

open (SCRIPT, ">$filepath");

print SCRIPT $lines;
close (SCRIPT);
