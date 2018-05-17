#!/usr/bin/perl
use strict;
use warnings;
use Net::Ping;
use POSIX qw(strftime);

#4.2.2.2 anycast
#8.8.8.8 google-public-dns-a.google.com
#8.8.4.4 google-public-dns-b.google.com
#139.130.4.5 ns1.telstra.net
#4.2.2.1 anycast
#4.2.2.3 anycast
#4.2.2.4 anycast
#64.68.200.200 easydns
#24.26.192.184 tge7-1.wacotxnor-er02.texas.rr.com
#4.69.145.136 ae-3-80.edge3.Dallas1.Level3.net

sub main
{
 $|=1;
 my(@hosts)=("192.168.1.123","4.2.2.2","8.8.8.8","8.8.4.4","139.130.4.5","4.2.2.1","4.2.2.3","4.2.2.4","64.68.200.200","24.26.192.184","4.69.145.136");
 my($result)=0;
 my($host)=0;
 my($rndh)=0;
 my($connection)=0;
 my($counter)=0;
 my(@test)=(0,0,0,0,0,0,0,0,0,0);
 my($sumt)=0;
 while (1)
 {
   $counter=0;
   #check a random host
   $rndh=int(rand(10));
   $result=pingthehost($hosts[$rndh]);
   if ($result==1) {
	print ".";
	$connection=1;
   } else {
	print "\nConnection may be down using " . $hosts[$rndh] . " on ";
	print strftime("%a, %d %b %Y %H:%M:%S %z", localtime(time())) . "\n";
	$connection=0;
   }
   if ($connection==0) {
	@test=(0,0,0,0,0,0,0,0,0,0);
	$counter=0;
	$sumt=0;
	foreach $host (@hosts)
   	{
	   $result=pingthehost($host);
   	   if ($result==1) {
		print "/";
   	   } else {
	   	print "x";
   	   }
   	   $test[$counter]=$result;
	   $counter++;
  	}
	#print @test;
	$sumt = eval join '+', @test;
	if ($sumt<11) {
	   print " ==> Network is down, " . (11-$sumt) . " servers seem to have lost connection.\nRestarting netwok services...\n";
	   system("stop network-manager"); 
	   sleep(5);
	   system("start network-manager"); 
	   sleep(10);
	}
   }
   sleep(10);
 }
}

sub pingthehost
{
   my $host=$_[0];
   my $p = Net::Ping->new("icmp");
   #print "pinging $host \n";
   if ($p->ping($host)) {
	$p->close();
	return 1;
   } else {
   	$p->close();
	return 0;
   }
}

main();
