#!/usr/bin/perl
use Net::FTP;
use strict;
use warnings;
use diagnostics;
 
use File::Path;
use LWP::Simple;
use Config::Simple;

sub main {
    print "Downloading granules\n";
    my($julianday) = $ARGV[0];
    my($time) = $ARGV[1];
    my($thisyear)=$ARGV[2];
    my($thisjulday)=$ARGV[3];
    my($dir_name)={};
    my($granulename)={};
    my($downflag)={};
    my($procflag)={};
    my($event)={};
    my($pattn)={};
    my($newpattn)={};
    my($line)={};
    my($cfg)=new Config::Simple('config.ini');
    my($mpath)=$cfg->param("local.path_to_storage_of_files");
    $mpath="$mpath/$thisyear/$julianday/";
    my($filetocheck)={};
    my($dir)={};
    my($fileexisting1)={};
    my($fileexisting2)={};
    my($ftp)={};
    my($ftp2)={};
    my($ftpsrv)="";
    my($ftpusr)="";
    my($ftppwd)="";
    my($flagfound)=0;
    my($dataCol1km)={};
    my($dataColgeo)={};
    #open data to download text file=============================================
    my($data_file)=$cfg->param("local.tmp_file_keeps_control_of_downloads");
    open(DAT, $data_file) || warn("Could not open file!");
    my(@raw_data)=<DAT>;
    close(DAT);
    #==============================================================================
    my($currjulday)=$julianday-1; #this accounts for one day old files
    my($curryear)=$thisyear;
    $currjulday = sprintf("%3d", $currjulday);
    $currjulday=~ tr/ /0/;

    foreach $event (@raw_data) { 
        chomp($event);
        ($granulename,$downflag,$procflag)=split(/\|/,$event);
        $filetocheck="$mpath$granulename/$granulename-1km.jpg";
        if (-e $filetocheck) {
            print "$granulename is already processed\n";
            #update file to indicate that granules are already downloaded================
            $pattn=$granulename . "|" . $downflag . "|" . $procflag . "\n";
            $newpattn=$granulename . "|y|" . $procflag . "\n";
            open(FILE,$data_file) || warn("Cannot Open " . $data_file . " File");
            my(@fcont) = <FILE>;
            close FILE;
            open(FOUT,">$data_file") || warn("Cannot Open " . $data_file . " File");
            foreach $line (@fcont) {
                if ($line eq $pattn) {
                    print FOUT $newpattn;
                }
                else {
                    print FOUT $line;
                }
            }
            close FOUT;
            #==============================================================================
        }
        $|=1; sleep(1);
        if (($downflag eq "n") && (not (-e $filetocheck))) {
            $dir = $mpath . $granulename;
            #update file to indicate that we are in the process of download================
            $pattn=$granulename . "|" . $downflag . "|" . $procflag . "\n";
            $newpattn=$granulename . "|p|" . $procflag . "\n";
            open(FILE,$data_file) || warn("Cannot Open " . $data_file . " File");
            my(@fcont) = <FILE>;
            close FILE;
            open(FOUT,">$data_file") || warn("Cannot Open " . $data_file . " File");
            foreach $line (@fcont) {
                if ($line eq $pattn) {
                    print FOUT $newpattn;
                }
                else {
                    print FOUT $line;
                }
            }
            close FOUT;
            #==============================================================================
            my($syear)=substr($granulename,1,4);
            my($sday)=substr($granulename,5,3);
            my($stime)=substr($granulename,8,4);
            print "\nSat: Terra, Year: $syear, Day: $sday, Time: $stime. ";
            
            #Check if files already exist
            $fileexisting1=$dir . "/MOD021KM.A" . $syear . $sday . "." . $stime . ".hdf";
            $fileexisting2=$dir . "/MOD03.A" . $syear . $sday . "." . $stime . ".hdf";
            unless ((-e $fileexisting1) && (-e $fileexisting2)) {
                #this bracket is closed after ftp closes

                #connect to nasa with two different accounts===================================
                $currjulday=$currjulday+(($curryear-$syear)*365);
                if (($syear<=$curryear) && ($sday<$thisjulday)) {
                    $ftpsrv=$cfg->param("nasa.ftp_server_1");
                    $ftpusr=$cfg->param("nasa.ftp_server_user_1");
                    $ftppwd=$cfg->param("nasa.ftp_server_password_1");
                    $ftp = Net::FTP->new("$ftpsrv", Debug => 0, Passive => 1)
                        or warn "Cannot connect to some.host.name: $@";
                    $ftp->login("$ftpusr","$ftppwd")
                        or warn "Cannot login " . $ftp->message;
                    $ftp->binary();
                }
                elsif ($time==0) {
                    $ftpsrv=$cfg->param("nasa.ftp_server_2");
                    $ftpusr=$cfg->param("nasa.ftp_server_user_2");
                    $ftppwd=$cfg->param("nasa.ftp_server_password_2");
                    $ftp = Net::FTP->new("$ftpsrv", Debug => 0, Passive => 1)
                        or warn "Cannot connect to some.host.name: $@";
                    $ftp->login("$ftpusr","$ftppwd")
                        or warn "Cannot login " . $ftp->message;
                    $ftp->binary();
                }
                else {
                    $ftpsrv=$cfg->param("nasa.ftp_server_3");
                    $ftpusr=$cfg->param("nasa.ftp_server_user_3");
                    $ftppwd=$cfg->param("nasa.ftp_server_password_3");
                    $ftp = Net::FTP->new("$ftpsrv", Debug => 0, Passive => 1)
                        or warn "Cannot connect to some.host.name: $@";
                    $ftp->login("$ftpusr","$ftppwd")
                        or warn "Cannot login " . $ftp->message;
                    $ftp->binary();
                }
                #==============================================================================
                
        
                #gets 1km data if it doesnot exist
                my(@files)={};
                my($file)={};
                $flagfound=0;
                my($filefound)={};
                my($localsize)=0;
                my($remotesize)=0;
                my($ftpfile)={};
                my($filetolook)={};
                my($file_name) = "*" . $syear . $sday . "." . $stime . "*.hdf";
                my($file_part) = $syear . $sday . "." . $stime . ".";
                $dir_name={};
                
                @files = <*OD021KM*.hdf>;
                foreach $file (@files) {
                    $filetolook=grep {/$file_part/}$file;
                    if ($filetolook==1) {
                        $filefound=$file;
                        $localsize= -s $filefound;
                        if ($thisyear<=2012) {
                            $dataCol1km=$cfg->param("nasa.data_collection_1km_1");
                            $dir_name = "$dataCol1km/$syear/$sday"; 
                            print "\n $dir_name \n";
                            $ftp->cwd($dir_name);
                            if ($ftp->pwd() ne $dir_name) {
                                $dataCol1km=$cfg->param("nasa.data_collection_1km_2");
                                $dir_name = "$dataCol1km/$syear/$sday"; 
                                print "\n $dir_name \n";
                                $ftp->cwd($dir_name);
                                if ($ftp->pwd() ne $dir_name) {
                                    $dataCol1km=$cfg->param("nasa.data_collection_1km_3");
                                    $dir_name = "$dataCol1km/$syear/$sday"; 
                                }
                            }                    
                        }
                        else {
                            $dir_name = $cfg->param("nasa.data_collection_1km_4");
                            $dir_name = "$dir_name/$syear/$sday"; 
                        }
                        $ftp->cwd($dir_name)
                            or warn "Cannot change working directory " . $ftp->message;
                        #print "A: The ftp directory is " . $ftp->pwd() . " is this right?\n";
                        #print "A: The filename to look is " . $file_name . " is this right?\n";
                        my(@file_list) = $ftp->ls("$file_name")
                            or warn "granule does not exist on ftp server " . $ftp->message;
                        foreach $ftpfile (@file_list) {
                            $remotesize= $ftp->size($ftpfile);
                        }
                        if ($localsize==$remotesize) { $flagfound=1; } else { $flagfound=0; }
                    }
                }
                if ($flagfound==1) {
                    print "1000m OK, ";
                } else {
                    if ($thisyear<=2012) {
                        $dataCol1km=$cfg->param("nasa.data_collection_1km_1");
                        $dir_name = "$dataCol1km/$syear/$sday"; 
                        $ftp->cwd($dir_name);
                        if ($ftp->pwd() ne $dir_name) {
                            $dataCol1km=$cfg->param("nasa.data_collection_1km_2");
                            $dir_name = "$dataCol1km/$syear/$sday"; 
                            print "\n $dir_name 192 \n";
                            $ftp->cwd($dir_name);
                            print "The ftp directory is " . $ftp->pwd() . " is this right? 194\n";
                            if ($ftp->pwd() ne $dir_name) { 
                                $dataCol1km=$cfg->param("nasa.data_collection_1km_3");
                                $dir_name = "$dataCol1km/$syear/$sday"; 
                            }
                        }
                    }
                    else {
                        $dir_name = $cfg->param("nasa.data_collection_1km_4");
                        $dir_name = "$dir_name/$syear/$sday"; 
                    }
                    $ftp->cwd($dir_name)
                        or warn "Cannot change working directory " . $ftp->message;
                    #print "B: The ftp directory is " . $ftp->pwd() . " is this right?\n";
                    #print "B: The filename to look is " . $file_name . " is this right?\n";                
                    my(@file_list) = $ftp->ls("$file_name")
                        or warn "granule does not exist on ftp server " . $ftp->message;
                    foreach $ftpfile (@file_list) {
                        print "\n downloading " . $ftpfile . " ... ";
                        $ftp->get("$ftpfile", $dir . "/MOD021KM.A" . $syear . $sday . "." . $stime . ".hdf")
                            or warn "get failed " . $ftp->message; 
                    }
                }
                $ftp->quit;
                
                #gets gelocation data if it doesnot exist
                #connect to nasa===============================================================
                if (($syear<=$curryear) && ($sday<$thisjulday)) {
                    $ftpsrv=$cfg->param("nasa.ftp_server_1");
                    $ftpusr=$cfg->param("nasa.ftp_server_user_1");
                    $ftppwd=$cfg->param("nasa.ftp_server_password_1");
                    $ftp2 = Net::FTP->new("$ftpsrv", Debug => 0, Passive => 1)
                        or warn "Cannot connect to some.host.name: $@";
                    $ftp2->login("$ftpusr","$ftppwd")
                        or warn "Cannot login " . $ftp2->message;
                    $ftp2->binary();
                }
                elsif ($time==0) {
                    $ftpsrv=$cfg->param("nasa.ftp_server_2");
                    $ftpusr=$cfg->param("nasa.ftp_server_user_2");
                    $ftppwd=$cfg->param("nasa.ftp_server_password_2");
                    $ftp2 = Net::FTP->new("$ftpsrv", Debug => 0, Passive => 1)
                        or warn "Cannot connect to some.host.name: $@";
                    $ftp2->login("$ftpusr","$ftppwd")
                        or warn "Cannot login " . $ftp2->message;
                    $ftp2->binary();
                }
                else {
                    $ftpsrv=$cfg->param("nasa.ftp_server_3");
                    $ftpusr=$cfg->param("nasa.ftp_server_user_3");
                    $ftppwd=$cfg->param("nasa.ftp_server_password_3");
                    $ftp2 = Net::FTP->new("$ftpsrv", Debug => 0, Passive => 1)
                        or warn "Cannot connect to some.host.name: $@";
                    $ftp2->login("$ftpusr","$ftppwd")
                        or warn "Cannot login " . $ftp2->message;
                    $ftp2->binary();
                }
                #==============================================================================
                
                $file={};
                $flagfound=0;
                $filefound={};
                $localsize=0;
                $remotesize=0;
                $ftpfile={};
                $dir_name={};
                
                @files = <*OD03*.hdf>;
                foreach $file (@files) {
                    $filetolook=grep {/$file_part/}$file;
                    if ($filetolook==1) {
                        $filefound=$file;
                        $localsize= -s $filefound;
                        if ($thisyear<=2012)  {
                            $dataColgeo=$cfg->param("nasa.data_collection_geo_1");
                            $dir_name = "$dataColgeo/$syear/$sday"; 
                            $ftp2->cwd($dir_name);
                            if ($ftp2->pwd() ne $dir_name) {
                                $dataColgeo=$cfg->param("nasa.data_collection_geo_2");
                                $dir_name = "$dataColgeo/$syear/$sday"; 
                                $ftp2->cwd($dir_name);
                                if ($ftp2->pwd() ne $dir_name) { 
                                    $dataColgeo=$cfg->param("nasa.data_collection_geo_3");
                                    $dir_name = "$dataColgeo/$syear/$sday"; 
                                }
                            }
                            
                        }
                        else {
                            $dir_name = $cfg->param("nasa.data_collection_geo_4");
                            $dir_name = "$dir_name/$syear/$sday"; 
                        }
                        $ftp2->cwd($dir_name)
                            or warn "Cannot change working directory " . $ftp2->message;
                        #print "C: The ftp directory is " . $ftp2->pwd() . " is this right?\n";
                        #print "C: The filename to look is " . $file_name . " is this right?\n";                
                        my(@file_list) = $ftp2->ls("$file_name")
                            or warn "granule does not exist on ftp server " . $ftp2->message;
                        foreach $ftpfile (@file_list) {
                            $remotesize= $ftp2->size($ftpfile);
                        }
                        if ($localsize==$remotesize) { $flagfound=1; } else { $flagfound=0; }
                    }
                }
                if ($flagfound==1) {
                    print "Geolocations OK, ";
                } else {
                    if ($thisyear<=2012) {
                        $dataColgeo=$cfg->param("nasa.data_collection_geo_1");
                        $dir_name = "$dataColgeo/$syear/$sday"; 
                        $ftp2->cwd($dir_name);
                        if ($ftp2->pwd() ne $dir_name) {
                            $dataColgeo=$cfg->param("nasa.data_collection_geo_2");
                            $dir_name = "$dataColgeo/$syear/$sday"; 
                            $ftp2->cwd($dir_name);
                            if ($ftp2->pwd() ne $dir_name) {
                                $dataColgeo=$cfg->param("nasa.data_collection_geo_3");
                                $dir_name = "$dataColgeo/$syear/$sday"; 
                            }
                        }
                    }
                    else {
                        $dir_name = $cfg->param("nasa.data_collection_geo_4");
                        $dir_name = "$dir_name/$syear/$sday"; 
                    }
                    $ftp2->cwd($dir_name)
                        or warn "Cannot change working directory to $dir_name using parameter $dataColgeo. Error: " . $ftp2->message;
                    #print "D: The ftp directory is " . $ftp2->pwd() . " is this right?\n";
                    #print "D: The filename to look is " . $file_name . " is this right?\n";                
                    my(@file_list) = $ftp2->ls("$file_name")
                        or warn "granule does not exist on ftp server " . $ftp2->message;
                    foreach $ftpfile (@file_list) {
                        print "\n downloading " . $ftpfile . " ... ";
                        $ftp2->get("$ftpfile", $dir . "/MOD03.A" . $syear . $sday . "." . $stime . ".hdf")
                            or warn "get failed " . $ftp2->message; 
                    }
                }
        
                print "finished! \n";
                $ftp2->quit;
            } #this brackets close verification of file existence    


            #update file to indicate that we are finished with the process of download=====
            $pattn=$granulename . "|p|" . $procflag . "\n";
            $newpattn=$granulename . "|y|" . $procflag . "\n";
            open(FILE,$data_file) || warn("Cannot Open " . $data_file . " File");
            @fcont = <FILE>;
            close FILE;
            open(FOUT,">$data_file") || warn("Cannot Open " . $data_file . " File");
            foreach $line (@fcont) {
                if ($line eq $pattn) {
                    print FOUT $newpattn;
                }
                else {
                    print FOUT $line;
                }
            }
            close FOUT;
            #==============================================================================

        }
    } 
}

main();


