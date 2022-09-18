#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use utf8;
my ($URL, $ADMIN, $PASSWORD) = @ARGV;

$| = 1;
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
$mech->content() =~ m!<tr><td>Is staff</td><td>Yes</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Is superuser</td><td>Yes</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>$ADMIN</td><td>(\w+ \d+, \d{4}, \d{1,2}:\d{2}:\d{2})</td></tr>!
	or die $mech->content();
my $last_logon = $1;

$mech->follow_link(text => "Logged in as $ADMIN", url => "/");

$mech->content() =~ m!<tr><td>Username</td><td>$ADMIN</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Is staff</td><td>Yes</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Is superuser</td><td>Yes</td></tr>!
	or die $mech->content();

$mech->form_id('logout-form');
$mech->submit();
$mech->follow_link(text => "Not logged in", url => "/");
$mech->content() =~ m!<tr><td>$ADMIN</td><td>$last_logon</td></tr>!
	or die $mech->content();

sleep(1.1);

$mech->follow_link(text => "admin", url => "/admin/");
$mech->set_visible($ADMIN, $PASSWORD);
$mech->submit();

my $BUSER = "bob";
my $BPASSWORD = "x3zIownc6s";

$mech->follow_link(text => "Add", url => "/admin/auth/user/add/");
$mech->form_id('user_form');
$mech->set_visible($BUSER, $BPASSWORD, $BPASSWORD);
$mech->click_button(value => "Save and add another");

my $DUSER = "david";
my $DPASSWORD = "Oj7HFnKasj72";

$mech->form_id('user_form');
$mech->set_visible($DUSER, $DPASSWORD, $DPASSWORD);
$mech->click_button(value => "Save and continue editing");

$mech->form_id('user_form');
$mech->set_fields(first_name => 'David', last_name => 'Šiška', email => 'david@example.test');
$mech->current_form()->find_input('is_staff')->check();
$mech->submit();

$mech->form_id('logout-form');
$mech->submit();

$mech->get("/");
$mech->content() =~ m!<tr><td>$ADMIN</td><td>(\w+ \d+, \d{4}, \d{1,2}:\d{2}:\d{2})</td></tr>!
	or die $mech->content();
my $new_last_logon = $1;
$new_last_logon ne $last_logon or die;
$mech->content() =~ m!<tr><td>$BUSER</td><td>None</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>$DUSER</td><td>None</td></tr>!
	or die $mech->content();

$mech->follow_link(text => "Not logged in", url => "/");

sleep(1.1);

$mech->follow_link(text => "login", url => "/login");
$mech->field("username", $BUSER);
$mech->field("password", $BPASSWORD);
$mech->submit();

$mech->content() =~ m!<tr><td>$ADMIN</td><td>$new_last_logon</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>$BUSER</td><td>(\w+ \d+, \d{4}, \d{1,2}:\d{2}:\d{2})</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Is staff</td><td>No</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Is superuser</td><td>No</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>$DUSER</td><td>None</td></tr>!
	or die $mech->content();

$mech->follow_link(text => "Logged in as $BUSER", url => "/");

$mech->content() =~ m!<tr><td>$BUSER</td><td>(\w+ \d+, \d{4}, \d{1,2}:\d{2}:\d{2})</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Is staff</td><td>No</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Is superuser</td><td>No</td></tr>!
	or die $mech->content();

$mech->form_id('logout-form');
$mech->submit();

$mech->follow_link(text => "Not logged in", url => "/");

$mech->content() =~ m!<tr><td>$ADMIN</td><td>$new_last_logon</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>$BUSER</td><td>(\w+ \d+, \d{4}, \d{1,2}:\d{2}:\d{2})</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>$DUSER</td><td>None</td></tr>!
	or die $mech->content();

$mech->follow_link(text => "login", url => "/login");
$mech->field("username", $DUSER);
$mech->field("password", $DPASSWORD);
$mech->submit();

$mech->content() =~ m!<tr><td>$ADMIN</td><td>$new_last_logon</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>$DUSER</td><td>(\w+ \d+, \d{4}, \d{1,2}:\d{2}:\d{2})</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>First name</td><td>David</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Last name</td><td>Šiška</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Email</td><td>david\@example\.test</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Is staff</td><td>Yes</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Is superuser</td><td>No</td></tr>!
	or die $mech->content();

$mech->follow_link(text => "Logged in as $DUSER", url => "/");

$mech->content() =~ m!<tr><td>$DUSER</td><td>(\w+ \d+, \d{4}, \d{1,2}:\d{2}:\d{2})</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>First name</td><td>David</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Last name</td><td>Šiška</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Email</td><td>david\@example\.test</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Is staff</td><td>Yes</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>Is superuser</td><td>No</td></tr>!
	or die $mech->content();

$mech->form_id('logout-form');
$mech->submit();

$mech->follow_link(text => "Not logged in", url => "/");

$mech->content() =~ m!<tr><td>$ADMIN</td><td>$new_last_logon</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>$BUSER</td><td>(\w+ \d+, \d{4}, \d{1,2}:\d{2}:\d{2})</td></tr>!
	or die $mech->content();
$mech->content() =~ m!<tr><td>$DUSER</td><td>(\w+ \d+, \d{4}, \d{1,2}:\d{2}:\d{2})</td></tr>!
	or die $mech->content();

print "$0 OK.\n";
