#!/usr/bin/perl
use strict;
use warnings;
 
use LWP::UserAgent;
use HTTP::Cookies;
use File::Find;
use HTTP::DAV;

sub main
{
	my($julianday) = $ARGV[0];

    # Create the fake browser (user agent).
    my $ua = LWP::UserAgent->new();
 
    $ua->agent("Mozilla/8.0");
 
    # Get some HTML.
    my $response = $ua->get("http://rapidfire.sci.gsfc.nasa.gov/cgi-bin/imagery/realtime.cgi?date=2012$julianday");
 
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
        " bytes of data to '$save'.\n";


	#create the new html file by reading the downloaded file and adding header and footer
	open NASAFILE, "<", "nasa.htm" or die $!;
	open MyFILE, ">", "/media/PABLODISK/privas/Projects/dust/hdf/test/$julianday/index.htm" or die $!;
	#adding headers
	print MyFILE "<html><head><title>Dust Aerosol Automatic Detection - Near Real Time (Orbit Swath) Images</title>\n";
	print MyFILE "<link rel='stylesheet' href='../styles/realtime.css' type='text/css'>\n";
	print MyFILE "<link rel='stylesheet' href='../styles/jquery-ui-1.8.2.custom.css' type='text/css'>\n";
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
	print MyFILE "<div style='background: white; color: black; text-align: center;'>\n";
	print MyFILE "-= Copyright 2012 (R) Pablo Rivas Perea =-         <a href='../disclaimer.html'>Disclaimer</a>\n";
	print MyFILE "</div>\n";
	print MyFILE "<div style='background: black; color: white; position: absolute; top: 27px;'>\n";
	print MyFILE "<p class='boldTitle'>Near Real Time (Orbit Swath) Images</p>\n";
	print MyFILE "<p class='boldTitle'>\n";
	print MyFILE "  Date:\n";
	print MyFILE "  2012/$julianday \n";
	print MyFILE "</p>\n";
	#end header
	my($flagstart)=0;
	my($flagstop)=0;
	while (my $line = <NASAFILE>) 
	{
		if (($line =~ /cellpadding="10"/) && ($flagstart==1)) { $flagstop=1; }
		if (($line =~ /cellpadding="10"/) && ($flagstart==0)) { $flagstart=1; }
		if ($flagstop==0) 
		{
			if ($flagstart==1) 
			{ 
				if ($line =~ /class="thumbnail"/) 
				{ 
					my($granule)=substr($line,84,12); 
					print MyFILE "<a class='thumbnail' href='./" . $granule . "/" . $granule . "-1km.jpg' target='Single' onclick='Single=window.open('','Single','height=1030,width=810,location=yes,resizable=yes,scrollbars=yes,toolbar=yes'); Single.focus();'>"; 
				}
				elsif ($line =~ /<img alt=/) 
				{ 
					my($granule)=substr($line,154,12); 
					print MyFILE "<img alt='Thumbnail image for Terra/MODIS 2012/$julianday' border='1' src='./" . $granule . "/" . $granule . "-thumb.jpg' />";
				}
				elsif ($line =~ /<span><img src=/) 
				{ 
					my($granule)=substr($line,65,12); 
					print MyFILE "<span><img src='./" . $granule . "/" . $granule . "-tg.jpg'/></span>"; 
				}
				elsif ($line =~ /target="Orbit"/) 
				{ 
					my($granule)=substr($line,68,7); 
					print MyFILE "( <a href='http://rapidfire.sci.gsfc.nasa.gov/cgi-bin/imagery/single.cgi?image=orbitmap1.global." . $granule . ".gif' target='Orbit' onclick='Orbit=window.open('','Orbit','height=540,width=890,location=yes,resizable=yes,scrollbars=yes,toolbar=yes'); Orbit.focus();'>View Terra Orbit Tracks</a>)";
				}
				elsif (($line =~ /cellpadding="10"/) && ($flagstart==1) && ($flagstop==0))
				{
					$line=~s/"10"/"1"/;
					print MyFILE $line;
				}
				else 
				{ 
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


	#get list of files to upload
	my($remotedir)={};
	my(@parts)={};
	open MyFILE, ">", "filesindirectory.txt" or die $!;
	my $localdir = "/media/PABLODISK/privas/Projects/dust/hdf/test/$julianday";
	find(sub { print MyFILE $File::Find::name, "\n" if /\.*$/ },$localdir);
	close MyFILE;
	open MyFILES, "<", "filesindirectory.txt" or die $!;
	open FilesToUp, ">", "filestoupload.txt" or die $!;
	while (my $line = <MyFILES>) 
	{
		if (($line =~ /-1km.jpg/) || ($line =~ /-thumb.jpg/) || ($line =~ /-tg.jpg/) || ($line =~ /.js/) || ($line =~ /.css/)) 
		{
			@parts = split('/', $line);
			if( @parts > 1 ) { $remotedir= $parts[@parts - 2];} 
			print FilesToUp $remotedir . "|" . $line;
		}		
	}
	close MyFILES;
	close FilesToUp;

	#upload files to baylor or utep if its an odd or even day respectively
	open FilesToUp, "<", "filestoupload.txt" or die $!;
	$remotedir={};	
	my($localfile)={};
	my($url)={};
	my($d) = new HTTP::DAV;
	if ($julianday % 2) 
	{
		print "... Uploading to UTEP\n";
		$url = "https://mspace.utep.edu/privas/web";
		$d->credentials( -user=>"privas",-pass =>"t6emAfre!",-url =>$url);
		$d->open( -url=>$url )
	      		or warn("Couldn't open $url: " .$d->message . "\n");
		$url = "https://mspace.utep.edu/privas/web/$julianday";		
		$remotedir="$url/index.html";		
	}
	else
	{
		print "... Uploading to Baylor\n";
		$url = "https://bearspace.baylor.edu/Pablo_Rivas_Perea/www";
		$d->credentials( -user=>"Pablo_Rivas_Perea",-pass =>"t6emAfre!",-url =>$url);
		$d->open( -url=>$url )
	      		or warn("Couldn't open $url: " .$d->message . "\n");
		$url = "https://bearspace.baylor.edu/Pablo_Rivas_Perea/www/$julianday";
		$remotedir="$url/index.htm";
	}
	$d->mkcol( -url => "$url" );
	$d->cwd( -url=>$url );
	if ( $d->put(-local=>"$localdir/index.htm", -url=>$remotedir) ) 
	{
		print "successfully uploaded index file\n";
	} 
	else 
	{
		print "put failed: " . $d->message . "\n";
	}
	print "now uploading image files\n";
	while (my $fileupload = <FilesToUp>) 
	{
		($remotedir,$localfile)=split(/\|/, $fileupload);
		#print "remote direc is $remotedir\nlocal file is $localfile\nfile to upload is $fileupload\n";
		$d->mkcol( -url => "$url/$remotedir" );
     		if ( $d->put(-local=>$localfile,-url=>"$url/$remotedir") ) 
		{
      			print "."; $|=1;
   		} 
		else 
		{
      			print "put failed: " . $d->message . "\n$localfile to $url/$remotedir\n";
   		}
	}
   	$d->unlock( -url => $url );
}
 
main();
