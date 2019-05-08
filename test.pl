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

$mech->follow_link(text => "Not logged in", url => "/");
$mech->follow_link(text => "login", url => "/login");
$mech->set_visible($ADMIN, $PASSWORD);
$mech->submit();

$mech->content() =~ m!<tr><td>Username</td><td>$ADMIN</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>$ADMIN</td><td>(\w+ \d+, \d{4}, \d{1,2}:\d{2}:\d{2})</td></tr>!
	or die $mech->content();
my $last_logon = $1;

$mech->follow_link(text => "Logged in as $ADMIN", url => "/");

$mech->follow_link(text => "logout", url => "/logout");
$mech->follow_link(text => "Not logged in", url => "/");
$mech->content() =~ m!<tr><td>$ADMIN</td><td>$last_logon</td></tr>!
	or die $mech->content();

sleep(1.1);

$mech->follow_link(text => "admin", url => "/admin/");
$mech->set_visible($ADMIN, $PASSWORD);
$mech->submit();

my $USER = "bob";
my $UPASSWORD = "x3zIownc6s";

$mech->follow_link(text => "Add", url => "/admin/auth/user/add/");
$mech->set_visible($USER, $UPASSWORD, $UPASSWORD);
$mech->submit();

$mech->follow_link(text => "Log out", url => "/admin/logout/");

$mech->get("/");
$mech->content() =~ m!<tr><td>$ADMIN</td><td>(\w+ \d+, \d{4}, \d{1,2}:\d{2}:\d{2})</td></tr>!
	or die $mech->content();
my $new_last_logon = $1;
$new_last_logon ne $last_logon or die;
$mech->content() =~ m!<tr><td>$USER</td><td>None</td></tr>!
	or die $mech->content();

$mech->follow_link(text => "Not logged in", url => "/");

sleep(1.1);

$mech->follow_link(text => "login", url => "/login");
$mech->field("username", $USER);
$mech->field("password", $UPASSWORD);
$mech->submit();

$mech->content() =~ m!<tr><td>$ADMIN</td><td>$new_last_logon</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>$USER</td><td>(\w+ \d+, \d{4}, \d{1,2}:\d{2}:\d{2})</td></tr>!
	or die $mech->content();
$mech->follow_link(text => "Logged in as $USER", url => "/");
