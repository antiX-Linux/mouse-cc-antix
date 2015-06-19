#!/usr/bin/perl

#---------- Variables ----------#

$home=`echo \$HOME`;
chomp($home);
$filepath="$home/\.xinitrc";

$entryregex="xmodmap -e 'pointer =.*'";
$newentry="xmodmap -e 'pointer = $ARGV[0]'";


#---------- Begin Script ----------#

$lines=`cat $filepath`;

# replace entry with new one
$lines =~ s{$entryregex}{$newentry};

open (SCRIPT, ">$filepath");

print SCRIPT $lines;
close (SCRIPT);
