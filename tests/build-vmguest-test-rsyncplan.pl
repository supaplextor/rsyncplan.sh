#!/usr/bin/perl

# (C) Scott Edwards http://www.synapticmhz.com/l/via=build-vmguest-test-rsyncplan.sh/about.html
#
# TODO: Be less locally significant to the dev host. Let me run $anywhere. This can be tested as below (eventually). Wow, take that recursion!
# 

use warnings;
use strict;
use LWP::Simple;

my $distro	= 'debian';
my $arch	= 'amd64';

my %remote_sums;
my %local_sums;
my %local_isos;

my $remote_sums; # temp, easy
my $local_sums;
my $local_isos;

# FIXME: ask a debian isp ml how they'd approach this for their distro, and many others?

$remote_sums{debian}	= "http://ftp.debian.org/debian/dists/stable/main/installer-$arch/current/images/SHA256SUMS";
$local_sums{debian}	= "debian-stable-amd64-netinst-sums.txt";
# $local_isos{debian}	= "debian-stable-amd64-netinst-mini.iso";
$local_isos{debian}	= "/home/supaplex/iso-images/linux/debian/debian-stable-amd64-netinst-mini.iso";

$remote_sums		= $remote_sums{$distro};
$local_sums		= $local_sums{$distro};
$local_isos		= $local_isos{$distro};

# FIXME: dev hack.
-s $local_sums or mirror $remote_sums => $local_sums;

if (!-s $local_sums) {
	die "File not found, $local_sums, is $remote_sums ok?";
}

# This is a sign of rushed developemnt. I can just rewrite it clean next pass around, right? :)

use Data::Dumper;
sub dirname {
# this is dumb. just do it right soon.
	my $in = shift;
	my @m = split(qr(\/),$in);
	$in = pop @m;
# print Dumper \@m;
	my $return = join ("/" => @m);
#	warn $return;
	return $return;
}

if (-s $local_isos) {
	print "Found $local_isos\n";
} else {
	local $@ = '';
# FIXME: use filehandle

	open (S,"<",$local_sums) or $@ = "Cannot open $local_sums for read: $!";
	die $@ if $@;
	while (<S>) {
		next unless $_ =~ m!^([0-9a-fA-F]+)\s+(.*?/netboot/mini.iso)!;

		my $sum		= $1;
		warn		"sum is $sum";

		my $uri_right	= $2;
		warn		"uri_right is $uri_right";

		my $url		= dirname($remote_sums{$distro})."/$uri_right";
		warn		"url is $url";

		system join("", "aria2c", " -x5 ",
			"--auto-file-renaming=false ",
			" -d "	=> quotemeta(dirname($local_isos)),
			" -o "	=> quotemeta($local_isos),
			" " 	=> quotemeta($url));

		last;
	}
	close S;
}
