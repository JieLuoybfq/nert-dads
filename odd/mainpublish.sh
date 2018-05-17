#!/usr/bin/perl
#use strict;
#use warnings;
  
use Switch;
use Date::Leapyear;  
use LWP::UserAgent;
use HTTP::Cookies;
use File::Find;
use HTTP::DAV;
use List::MoreUtils 'any';
use File::Path qw(make_path remove_tree);
use Config::Simple;

sub main {
    my($julday)={};
    my($thisyear)={};
    my($start)={};
    my($end)={};
    my($fromyear)={};
    my($fromday)={};
    my($yeardays)={};
    my(@listofdays)={};
    my(@listofyears)={};
    my(@folders2del)={};
    my($cfg)=new Config::Simple('config.ini');    
    my($datapath)=$cfg->param("local.path_to_storage_of_files");
    my($uploadfolder)=$cfg->param("local.path_to_uploaded_files");
    my($amIdebugging)=1;

    while (1) {
    
        $start = time;
        $julday=julianDate();
        $thisyear=gettheyear();
        $julday = sprintf("%3d", $julday);
        $julday=~ tr/ /0/;
    
        #$julday=7;
        #$thisyear=2013;
        
        print "\nCurrent UTC date and time: " . gmtime . "\n";
        print "Today is Julian day $julday of the year $thisyear.\n"; 
    
        $fromday=$julday-10;
        if ($fromday<1) {   #means its new year's and we need to go back to the previous year
            $fromyear=$thisyear-1;
            $yeardays=isleap($fromyear);
            $fromday=$yeardays+$fromday;
            my($tmpcnt)=0;
            for (my $d=$fromday; $d<=$yeardays; $d++) {
                $listofdays[$tmpcnt]=$d;
                $listofyears[$tmpcnt]=$fromyear;
                $tmpcnt++;
            }
            for (my $d=1; $d<=$julday; $d++) {
                $listofdays[$tmpcnt]=$d;
                $listofyears[$tmpcnt]=$thisyear;
                $tmpcnt++;
            }
        } else {
            $fromyear=$thisyear;
            @listofyears =($fromyear, $fromyear, $fromyear, $fromyear, $fromyear,
                         $fromyear, $fromyear, $fromyear, $fromyear, $fromyear, $fromyear); 
            @listofdays = ($fromday,$fromday+1,$fromday+2,$fromday+3,$fromday+4,
                        $fromday+5,$fromday+6,$fromday+7,$fromday+8,$fromday+9,$fromday+10);
        }
       
        for (my $k=0; $k<=10; $k++) {    #to add leading zeros
            $listofdays[$k] = sprintf("%03d", $listofdays[$k]);
        }
        
        if ($amIdebugging) {
            for (my $k=0; $k<=10; $k++) {
                print "$listofdays[$k]\n";
            }
        }
    
    
        my($linkset)="<a href='../$listofdays[0]/index.htm'>$listofyears[0]/$listofdays[0]</a> " . 
                   "| <a href='../$listofdays[1]/index.htm'>$listofdays[1]</a> " . 
                   "| <a href='../$listofdays[2]/index.htm'>$listofdays[2]</a> " . 
                   "| <a href='../$listofdays[3]/index.htm'>$listofdays[3]</a> " . 
                   "| <a href='../$listofdays[4]/index.htm'>$listofdays[4]</a> " . 
                   "| <a href='../$listofdays[5]/index.htm'>$listofdays[5]</a> " . 
                   "| <a href='../$listofdays[6]/index.htm'>$listofdays[6]</a> " . 
                   "| <a href='../$listofdays[7]/index.htm'>$listofdays[7]</a> " . 
                   "| <a href='../$listofdays[8]/index.htm'>$listofdays[8]</a> " . 
                   "| <a href='../$listofdays[9]/index.htm'>$listofdays[9]</a> " . 
                   "| <a href='../$listofdays[10]/index.htm'>$listofyears[10]/$listofdays[10]</a> | \n";
    
        if ($amIdebugging) {
            print $linkset;
        }
        
        print "We will copy since day $fromday/$fromyear until $julday/$thisyear.\n";
        
        
        #THIS IS TO GET THE DIRECTORIES AND DELETE THOSE OLD ONES 
        
        my($dir) = $uploadfolder;
        $tmpcnt=0;
        opendir(DIR, $dir) or die $!;
        while (my $file = readdir(DIR)) {
            # A file test to check that it is a directory
            # Use -f to test for a file
            next unless (-d "$dir/$file");
            if (substr($file,0,1) eq ".") { #excludes directories . and ..
                next;
            }
            if (($file eq "styles") || ($file eq "javascript")) { #excludes web directories
                next;
            }
    
            if ($amIdebugging) {
                print "$file\n";
            }
            
            my($shouldkeep) = any { /$file/ } @listofdays;
            if (!$shouldkeep) {
                $shouldkeep=0;
                $folders2del[$tmpcnt]=$file;
                $tmpcnt++;
            }
    
            if ($amIdebugging) {
                print "Should I keep it? $shouldkeep \n";
            }
        }
        closedir(DIR);
        
    
        for (my $k=0; $k<$tmpcnt; $k++) {
            if ($amIdebugging) {
                print "$dir/$folders2del[$k]\n";
            }
            remove_tree("$dir/$folders2del[$k]");
        }
       
        #finally sync the files from remote/local? HD to local HD 
        for (my $k=0; $k<=10; $k++) {
            print("rsync -vzah --delete $datapath/$listofyears[$k]/$listofdays[$k] $uploadfolder/ \n");
            system("rsync -za --delete $datapath/$listofyears[$k]/$listofdays[$k] $uploadfolder/");
        }
    
        #lets remove all hdf and matlab files
        print("find $uploadfolder -type f -name '*.hdf' -exec rm {} \\; \n");
        system("find $uploadfolder -type f -name '*.hdf' -exec rm {} \\;");
    
        print("find $uploadfolder -type f -name '*.mat' -exec rm {} \\; \n");
        system("find $uploadfolder -type f -name '*.mat' -exec rm {} \\;");
    
        #remove 1km and 2km resolution as well
        print("find $uploadfolder -type f -name 'earth-1km.png' -exec rm {} \\; \n");
        system("find $uploadfolder -type f -name 'earth-1km.png' -exec rm {} \\;");
    
        print("find $uploadfolder -type f -name 'earth-2km.png' -exec rm {} \\; \n");
        system("find $uploadfolder -type f -name 'earth-2km.png' -exec rm {} \\;");
    
    #############################################################################
    #############################################################################
    
        for (my $k=0; $k<=10; $k++) {
            my($year) = $listofyears[$k];
            my($julianday) = $listofdays[$k];
        
            # Create the fake browser (user agent).
            my $ua = LWP::UserAgent->new();
         
            $ua->agent("Mozilla/8.0");
         
            # Get some HTML.
            #my $response = $ua->get("http://rapidfire.sci.gsfc.nasa.gov/cgi-bin/imagery/realtime.cgi?date=$year$julianday");
            my $response = $cfg->param("nasa.imgurl"); 
            $response = $ua->get("$response?date=$year$julianday");
         
            unless($response->is_success) {
                print "Error: " . $response->status_line;
            }
         
            # Let's save the output.
            my $save = "nasa.htm";
         
            unless(open SAVE, '>' . $save) {
                die "\nCannot create save file '$save'\n";
            }
         
            # Without this line, we may get a
            # 'wide characters in print' warning.
            binmode(SAVE, ":utf8");
         
            print SAVE $response->decoded_content;
         
            close SAVE;
         
            print "Saved " .
                length($response->decoded_content) .
                " bytes of data to '$save' ";
        
        
            #create the new html file by reading the downloaded file and adding header and footer
            open NASAFILE, "<", "nasa.htm" or die $!;
            if (!(-d ("$uploadfolder/$julianday"))) {
                print "\nDirectory $uploadfolder/$julianday does not exist!\n";
                next;
            }
            open MyFILE, ">", "$uploadfolder/$julianday/index.htm" or die $!;
            #adding headers
            print MyFILE "<html><head><title>Dust Aerosol Automatic Detection - Near Real Time (Orbit Swath) Images</title>\n";
            print MyFILE "<link rel='stylesheet' href='../styles/realtime.css' type='text/css'>\n";
            print MyFILE "<link rel='stylesheet' href='../styles/jquery-ui-1.8.2.custom.css' type='text/css'>\n";
            print MyFILE "<link rel='stylesheet' href='../styles/baylor.css' type='text/css'>\n";
            print MyFILE "<script type='text/javascript'>\n";
            print MyFILE "  var _gaq = _gaq || [];\n";
            print MyFILE "  _gaq.push(['_setAccount', 'UA-30187940-1']);\n";
            print MyFILE "  _gaq.push(['_trackPageview']);\n\n";
            print MyFILE "  (function() {\n";
            print MyFILE "    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;\n";
            print MyFILE "    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';\n";
            print MyFILE "    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);\n";
            print MyFILE "  })();\n";
            print MyFILE "</script>\n";
            print MyFILE "<script src='../javascript/jquery-1.4.2.min.js'></script>\n";
            print MyFILE "<script src='../javascript/jquery-ui-1.8.2.custom.min.js'></script>\n";
            print MyFILE "</head>\n";
            print MyFILE "<body>\n";
            print MyFILE "<div style='background: #f5002e; color: black; text-align: center;'>\n";
            print MyFILE "<a href='../ack.html'>Acknowledgements</a> | <a href='../disclaimer.html'>Disclaimer</a>\n";
            print MyFILE "</div>\n";
            print MyFILE "<div style='background: black; color: white; position: absolute; top: 27px;'>\n";
            print MyFILE "<div id='baylor_header'>\n";
            print MyFILE "<a href='https://www.marist.edu/compscimath'><img src='https://reev.us/images/marist_red.png'></a>\n";
            print MyFILE "<div id='ecs'>School of Computer Science and Mathematics</div></div><div id='blackbar'>&nbsp;</div>\n";
            print MyFILE "<p class='boldTitle'>Near Real Time (Orbit Swath) Images</p>\n";
            print MyFILE "<p class='boldTitle'>\n";
            print MyFILE "<span style='vertical-align: middle;'>\n &nbsp; &nbsp; Date:\n";
            print MyFILE "  $linkset \n";
            print MyFILE "</span> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <img src='../legend.png' style='vertical-align: middle;'/>\n";
            print MyFILE "</p>\n";
            print MyFILE "<p>\n<center>\n<a href='earth-4km.png'>4km</a> | <a href='earth-8km.png'>8km</a> | <a href='earth-16km.png'>16km</a> | <a href='earth-32km.png'>32km</a> | <a href='earth-64km.png'>64km</a>\n</center>\n<center>\n";
            print MyFILE "<img src='earth-32km.png'>\n</center>\n</p>\n";
    
            #end header
            my($flagstart)=0;
            my($flagstop)=0;
            while (my $line = <NASAFILE>) {
                if (($line =~ /cellpadding="10"/) && ($flagstart==1)) { $flagstop=1; }
                if (($line =~ /cellpadding="10"/) && ($flagstart==0)) { $flagstart=1; }
                if ($flagstop==0) {
                    if ($flagstart==1) { 
                        if ($line =~ /class="thumbnail"/) { 
                            my($granule)=substr($line,84,12); 
                            print MyFILE "<a class='thumbnail' href='./" . $granule . "/" . $granule . "-1km.jpg' target='Single' onclick='Single=window.open('','Single','height=1030,width=810,location=yes,resizable=yes,scrollbars=yes,toolbar=yes'); Single.focus();'>"; 
                        }
                        elsif ($line =~ /<img alt=/) { 
                            my($granule)=substr($line,154,12); 
                            print MyFILE "<img alt='Thumbnail image for Terra/MODIS $year/$julianday' border='1' src='./" . $granule . "/" . $granule . "-thumb.jpg' />";
                        }
                        elsif ($line =~ /<span><img src=/) { 
                            my($granule)=substr($line,65,12); 
                            print MyFILE "<span><img src='./" . $granule . "/" . $granule . "-tg.jpg'/></span>"; 
                        }
                        elsif ($line =~ /target="Orbit"/) { 
                            my($granule)=substr($line,68,7); 
                            #print MyFILE "( <a href='http://rapidfire.sci.gsfc.nasa.gov/cgi-bin/imagery/single.cgi?image=orbitmap1.global." . $granule . ".gif' target='Orbit' onclick='Orbit=window.open('','Orbit','height=540,width=890,location=yes,resizable=yes,scrollbars=yes,toolbar=yes'); Orbit.focus();'>View Terra Orbit Tracks</a>)";
                            print MyFILE "( <a href='https://lance2.modaps.eosdis.nasa.gov/cgi-bin/imagery/single.cgi?image=orbitmap1.global." . $granule . ".gif' target='Orbit' onclick='Orbit=window.open('','Orbit','height=540,width=890,location=yes,resizable=yes,scrollbars=yes,toolbar=yes'); Orbit.focus();'>View Terra Orbit Tracks</a>)";
                        }
                        elsif (($line =~ /cellpadding="10"/) && ($flagstart==1) && ($flagstop==0)) {
                            $line=~s/"10"/"1"/;
                            print MyFILE $line;
                        }
                        else { 
                            print MyFILE $line; 
                        }
                        
                    }
                }
            }
            close NASAFILE;
            #add footer and close file
            print MyFILE "</div>\n";
            print MyFILE "</body>\n";
            print MyFILE "</html>\n";
            close MyFILE;
    
            print "--> $julianday/index.htm \n";
    
        }
    
    #############################################################################
    #############################################################################
    
    
    #this creates an htm file that redirects to the most recent data
    
    #============================================================================
    #============================================================================
        my($websiteurl) = $cfg->param("webserver.host_address");
            
        open MyFILE, ">", "$uploadfolder/index.htm" or die $!;
        print MyFILE "<!DOCTYPE html><html><head><title>Dust Aerosol Automatic Detection - Near Real Time (Orbit Swath) Images</title>\n";
        print MyFILE "<link rel='stylesheet' href='./styles/baylor.css' type='text/css'>\n";
        print MyFILE "<script type='text/javascript'>\n";
        print MyFILE "  var _gaq = _gaq || [];\n";
        print MyFILE "  _gaq.push(['_setAccount', 'UA-30187940-1']);\n";
        print MyFILE "  _gaq.push(['_trackPageview']);\n\n";
        print MyFILE "  (function() {\n";
        print MyFILE "    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;\n";
        print MyFILE "    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';\n";
        print MyFILE "    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);\n";
        print MyFILE "  })();\n";
        print MyFILE "</script>\n";
        print MyFILE "<script src='./javascript/jquery-1.4.2.min.js'></script>\n";
        print MyFILE "<script src='./javascript/jquery-ui-1.8.2.custom.min.js'></script>\n"; 
        print MyFILE "<meta http-equiv='REFRESH' content='3;url=$websiteurl/$julday/index.htm'></head>\n";
        print MyFILE "<body>\n";
        print MyFILE "<div id='body_wrapper'><div id='baylor_header'>\n";
        print MyFILE "<a href='https://www.marist.edu/compscimath'><img src='https://reev.us/images/marist_red.png'></a>\n";
        print MyFILE "</div><div id='blackbar'>&nbsp;</div>\n";
        print MyFILE "<br/><br/><br/><h3>Redirecting to the latest information...</h3><br/><br/><br/>\n";
        print MyFILE "</div></body>\n";
        print MyFILE "</html>\n";
        close MyFILE;
    
    
    #============================================================================
    #============================================================================
    
    
    
        #final housekeeping and upload

        my($hostuser) = $cfg->param("webserver.host_user");
        my($hostname) = $cfg->param("webserver.host_name");
        my($hostfolder) = $cfg->param("webserver.host_folder");


        system("rm $uploadfolder/nasa.htm");
        system("chmod -R +r $uploadfolder");
        system("chmod -R +x $uploadfolder");
    
        print("rsync -vzahe ssh --delete $uploadfolder/ $hostuser\@$hostname:$hostfolder/ \n");
        system("rsync -vzahe ssh --delete $uploadfolder/ $hostuser\@$hostname:$hostfolder/");
    
    
    
        #system("./getwww.sh $julday 5 $thisyear");
        #system("./getimgs.sh $julday $thisyear"); 
        #system("./gethdfs.sh $julday 5 $thisyear");
        #system("/usr/local/bin/matlab -nodesktop -nosplash -r \"rfscript('$julday','$thisyear')\"");
        #system("/usr/local/bin/matlab -nodesktop -nosplash -r \"testsc('$julday','$thisyear')\"");
        $end = time;
        if (300>($end - $start)) {
            print "\nCurrent UTC date and time: " . gmtime . "\n";
            print " => finished and waiting 5min \n";
            sleep(300);
        } else {
            print " -> finished and continuing again\n";        
            sleep(1);
        }
        
    }
    
}
    
sub isleap {
    my($year) = @_;  #shift;
    if ($year % 100 == 0) {
        if ($year % 400 == 0) {
            return 366;
        } else {
            return 365;
        }
    }
    if ($year % 4 == 0) {
        return 366;
    } else {
        return 365;
    }
}

sub leapDay {                            
    my($year,$month,$day) = @_;
    if ($year % 4) {
        return(0);
    }

    if (!($year % 100)) {         # years that are multiples of 100
                                # are not leap years
        if ($year % 400) {        # unless they are multiples of 400
            return(0);
        }
    }

    if ($month < 2) {
        return(0);
    } elsif (($month == 2) && ($day < 29)) {
        return(0);
    } else {
        return(1);
    }
}
       
sub julianDate {     
    my(@theJulianDate) = ( 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 );      
    my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday);
    ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday) = gmtime;

    # GET A 4 HOUR DELAY
    #==================================
    $hour=$hour-4;
    my($tmpmon)={};
    my($tmpyear)={};
    if ($hour<0)    { $hour=$hour+24; $mday=$mday-1; $yday=$yday-1; }   #has to go back a day
    if ($mday<=0)   {       #has to go back a month
        $mon=$mon-1;
        $tmpmon=$mon;
        if ($mon<0) { $tmpmon=11; } 
        switch($tmpmon) {
            case [0,2,4,6,7,9,11] {     #jan, mar, may, jul, aug, oct, dec=31 days
                $mday=$mday+31;
            }
            case [3,5,8,10] {           # apr, jun, sep, nov=30 days
                $mday=$mday+30;
            }
            case 1 {                    #february could be 28 or 29
                $mday=$mday+28+isleap(1900+$year);
            }
            else { print "error in switch\n"; }
        }
    }    
    if ($mon<0)    {                                       #has to go back a yeari
        $year=$year-1;  #goes to the previous year
        $mon=11;        #goes to december
        $yday=$yday+364+&leapDay($year,$mon,$mday); #goes to last year's julian day
    }   
    #=================================

    if (defined($yday)) {
        return($yday+1);
    } else {
        return($theJulianDate[$mon] + $mday + &leapDay($year,$mon,$mday));
    }
}

sub gettheyear {     
    my($thecurrentyear) = 0;
    my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday);
    ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday) = gmtime;

    # GET A 4 HOUR DELAY
    #==================================

    $hour=$hour-4;
    my($tmpmon)={};
    my($tmpyear)={};
    if ($hour<0)    { $hour=$hour+24;   $mday=$mday-1; }    #has to go back a day
    if ($mday<=0)   {                                       #has to go back a month
        $mon=$mon-1;
        $tmpmon=$mon;
        if ($mon<0) { $tmpmon=11; } 
        switch($tmpmon) {
            case [0,2,4,6,7,9,11] {     #jan, mar, may, jul, aug, oct, dec=31 days
                $mday=$mday+31;
            }
            case [3,5,8,10] {           # apr, jun, sep, nov=30 days
                $mday=$mday+30;
            }
            case 1 {                    #february could be 28 or 29
                $mday=$mday+28+isleap(1900+$year);
            }
            else { print "error in switch\n"; }
        }
    }    
    if ($mon<0)    {                                       #has to go back a year
        $year=$year-1;  #goes to the previous year
        $mon=11;        #goes to december
    }   
    #=================================

    if (defined($yday)) {
        $thecurrentyear=$year+1900;
        return($thecurrentyear);
    } else {
        $thecurrentyear=-1;
        return($thecurrentyear);
    }
}
      

main();


