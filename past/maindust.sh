#!/usr/bin/perl
use strict;
use warnings;
use Switch;
use Date::Leapyear;  
use Config::Simple;

sub main {
    while(1) {
        my($juldayn)={};
        my($julday)={};
        my($thisyear)={};
        my($cfg)=new Config::Simple('config.ini');
        my($datatodownload)={};
        my($datapath)={};
        my($modelpath)={};
        my($matlabpath)={};

        $juldayn=julianDate();
        $thisyear=gettheyear();

        for ($julday = $juldayn-21; $julday < $juldayn; $julday++) {
            $julday = $julday+0;
            if ($julday<1) {
                next;
            }
            $julday = sprintf("%3d", $julday);
            $julday=~ tr/ /0/;
            $datatodownload=$cfg->param("local.tmp_file_keeps_control_of_downloads");
            $datapath=$cfg->param("local.path_to_storage_of_files");
            $modelpath=$cfg->param("matlab.model_path");
            $matlabpath=$cfg->param("matlab.path_to_executable");
            print "UTC date: " . gmtime . "\n";
            print "Julian day $julday of $thisyear\n"; 

            system("./getwww.sh $julday 0 $thisyear");
            system("./getimgs.sh $julday $thisyear"); 
            system("./gethdfs.sh $julday 0 $thisyear $juldayn");
            system("$matlabpath/matlab -nodesktop -nosplash -r \"rfscript('$julday','$thisyear','$datatodownload','$datapath','$modelpath')\"");
            system("./getwww.sh $julday 5 $thisyear");
            system("./getimgs.sh $julday $thisyear"); 
            system("./gethdfs.sh $julday 5 $thisyear $juldayn");
            system("$matlabpath/matlab -nodesktop -nosplash -r \"rfscript('$julday','$thisyear','$datatodownload','$datapath','$modelpath')\"");

            system("./getwww.sh $julday 0 $thisyear");
            system("./getimgs.sh $julday $thisyear"); 
            system("./gethdfs.sh $julday 0 $thisyear $juldayn");
            system("$matlabpath/matlab -nodesktop -nosplash -r \"rfscript('$julday','$thisyear','$datatodownload','$datapath','$modelpath')\"");
            system("./getwww.sh $julday 5 $thisyear");
            system("./getimgs.sh $julday $thisyear"); 
            system("./gethdfs.sh $julday 5 $thisyear $juldayn");
            system("$matlabpath/matlab -nodesktop -nosplash -r \"rfscript('$julday','$thisyear','$datatodownload','$datapath','$modelpath')\"");
            system("$matlabpath/matlab -nodesktop -nosplash -r \"testsc('$julday','$thisyear','$datapath','$modelpath')\"");
            
            #system("./mainpublish.sh $julday");
            
            sleep(1);
        }
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

    # GET A 3 HOUR DELAY
    #==================================
    $hour=$hour-3;
    my($tmpmon)={};
    my($tmpyear)={};
    if ($hour<0)    { $hour=$hour+24; $mday=$mday-1; $yday=$yday-1; }   #has to go back a day
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
    
    # GET A 3 HOUR DELAY
    #==================================

    $hour=$hour-3;
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
