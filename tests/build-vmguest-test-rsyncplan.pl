#!/usr/bin/perl

# (C) Scott Edwards 2015 - q+d guest vm gen
# About: http://www.synapticmhz.com/l/via=build-vmguest-test-rsyncplan.sh/about.html
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

# make sure install iso is here.
# download if need be.

if (-s $local_isos) {
	print qq(Found "$local_isos"\n);
	my $args = join(" " => $local_isos);
	system ("sha256sum",$args);
} else {
	print qq(Downloading "$local_isos" (checking sha256sums).\n);
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

		system ("wget",
		join(" " => quotemeta($url), "-O" => quotemeta($local_isos))
		);

		last;
	}
	close S;
}

my $GUEST_NAME		= "clean-debian-stable-$$";
my $GUEST_RAM		= "500mb";

my $VBoxManage		= "VBoxManage";
  $VBoxManage		= "echo";

my $qm_GUEST_NAME	= quotemeta $GUEST_NAME;
my $qm_GUEST_RAM	= quotemeta $GUEST_RAM;

sub createvm { return system ($VBoxManage, createvm => @_) };
sub modifyvm { return system ($VBoxManage, modifyvm => @_) };

createvm qq(--name "${qm_GUEST_NAME}" --register);
modifyvm qq("${qm_GUEST_NAME}" --memory ${qm_GUEST_RAM} --acpi on --boot1 dvd);
modifyvm qq("${qm_GUEST_NAME}" --ostype Debian);
modifyvm qq("${qm_GUEST_NAME}" --nic1 bridged --bridgeadapter1 eth0);
modifyvm qq("${qm_GUEST_NAME}" --nictype1 virtio);
#       modifyvm "${qm_GUEST_NAME}" --macaddress1 XXXXXXXXXXXX

##### DISK #####
my $SATA="SATA Controller";
my $VMs="~/VirtualBox VMs/";

sub createhd		{ return system ($VBoxManage, createhd		=> @_) };
sub storagectl		{ return system ($VBoxManage, storagectl	=> @_) };
sub storageattach	{ return system ($VBoxManage, storageattach	=> @_) };
sub unregistervm	{ return system ($VBoxManage, unregistervm	=> @_) };

createhd qq(--filename "${VMs}${qm_GUEST_NAME}/${qm_GUEST_NAME}_sda.vdi" --size 10000);
storagectl qq("${qm_GUEST_NAME}" --name "$SATA" --add sata);
storageattach qq("${qm_GUEST_NAME}" --storagectl "$SATA" --port 0 --device 0 --type hdd --medium "${VMs}${qm_GUEST_NAME}/${qm_GUEST_NAME}_sda.vdi");
storageattach qq("${qm_GUEST_NAME}" --storagectl "$SATA" --port 1 --device 0 --type dvddrive --medium ).quotemeta($local_isos);

unregistervm qq("${qm_GUEST_NAME}" --delete);




