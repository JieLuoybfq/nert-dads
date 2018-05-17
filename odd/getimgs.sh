#!/usr/bin/perl
use strict;
use warnings;
 
use File::Path;
use LWP::Simple;
use Config::Simple;

sub main {
    print "Downloading images\n";
    my($julianday) = $ARGV[0];
    my($thisyear) = $ARGV[1];
    my($cfg) = new Config::Simple('config.ini');
    my($data_file) = $cfg->param("local.tmp_file_with_url_of_images_to_download");        
    #open imgages to download text file=============================================
    open(DAT, $data_file) || die("Could not open file!");
    my(@raw_data)=<DAT>;
    close(DAT);
    #==============================================================================


    my($event)={};
    my($subdir)={};
    my($dir)={};
    my($mpath)=$cfg->param("local.path_to_storage_of_files");
    $mpath="$mpath/$thisyear/$julianday/";
    my($file)={};

    foreach $event (@raw_data) {
        $subdir=substr($event,72,12);
        if (substr($subdir,0,1) eq "A") {
            $dir = $mpath . $subdir;
            $file= $dir . "/" . $subdir . "-thumb.jpg";
        }
        else {
            $subdir = substr($event,70,12);
            $dir = $mpath . $subdir;
            $file= $dir . "/" . $subdir . "-tg.jpg";
        }

        eval { mkpath($dir) };
        if ($@) {
            print "Couldn't create $dir: $@";
        }
        else {
            unless (-e $file) {
                system("wget -q -O $file $event");
            }
        }
    }
}
 
main();


