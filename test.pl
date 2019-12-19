#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
my $URL = shift;
print "Will test against [$URL]\n";

use WWW::Mechanize ();
my $mech = new WWW::Mechanize(autocheck => 1, strict_forms => 1);
$mech->get($URL);

$mech->content() =~ /We will show the activity of users here/
	or die $mech->content();

