#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
my ($URL, $ADMIN, $PASSWORD) = @ARGV;
print "Will test against [$URL] with [$ADMIN/$PASSWORD]\n";

use WWW::Mechanize ();
my $mech = new WWW::Mechanize(autocheck => 1, strict_forms => 1);
$mech->get($URL);

$mech->content() =~ m!<tr><td>$ADMIN</td><td>None</td></tr>!
	or die $mech->content();

