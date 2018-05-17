#!/usr/bin/perl
use strict;
use warnings;
 
use LWP::UserAgent;
use HTTP::Cookies;
use HTML::SimpleLinkExtor;
use Config::Simple;
 
sub main {
    print "Downloading overpass information\n";
    my($julianday) = $ARGV[0];
    my($time) = $ARGV[1];   
    my($thisyear)=$ARGV[2];
    my $extor = HTML::SimpleLinkExtor->new();

    my $cfg = new Config::Simple('config.ini');
    my $imgurl = $cfg->param("nasa.imgurl"); 
    my $shorturl = $cfg->param("nasa.shorturl");

    #my $url   = "http://rapidfire.sci.gsfc.nasa.gov/cgi-bin/imagery/realtime.cgi?date=$thisyear$julianday";
    my $url   = "$imgurl?date=$thisyear$julianday";

    my $listOfFiles = $cfg->param("local.tmp_file_with_list_of_images");
    #this got replaced by a python program
    #$extor->parse_url($url);
    #open FILEInput, ">", "$listOfFiles" or die $!;
    #foreach my $src ( $extor->img ) {
    #    #print FILEInput "http://rapidfire.sci.gsfc.nasa.gov$src\n";
    #    print FILEInput "$shorturl$src\n";
    #} 
    #close FILEInput; 
    ##print "Data Saved \n";

    system("python nasadl.py '$url' '$listOfFiles'");

    my $dataToDownload = $cfg->param("local.tmp_file_keeps_control_of_downloads");
    my $imgToDownload = $cfg->param("local.tmp_file_with_url_of_images_to_download");
    open FILEInput, "<", "$listOfFiles" or die $!;
    open FILEDataDown, ">", "$dataToDownload" or die $!;
    open FILEImgDown, ">", "$imgToDownload" or die $!;

    while (my $line = <FILEInput>) { 
        if ($time==0) {
            if ((($line =~ /crefl1_/) || ($line =~ /geoinfo1/)) && ($line =~ /000-/)) {    
                print FILEImgDown $line;    
                if($line =~ m/1_143.(.*?)00-/) {
                    print FILEDataDown "$1|n|n\n";
                }
            }
        }
        elsif ($time==5) {
            if ((($line =~ /crefl1_/) || ($line =~ /geoinfo1/)) && ($line =~ /500-/)) {    
                print FILEImgDown $line;
                if($line =~ m/1_143.(.*?)00-/) {
                    print FILEDataDown "$1|n|n\n";
                }
            }
        }

    }
    close FILEInput;
    close FILEDataDown;
    close FILEImgDown;

}
 
main();


