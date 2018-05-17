#!/usr/bin/perl
#use strict;
#use warnings;
  
use LWP::UserAgent;
use HTTP::Cookies;
use File::Find;
use HTTP::DAV;

sub main
{
	my($julday) = $ARGV[0];
	print "Julian day is $julday\n";
    publishnewindex($julday);
	system("./publish.sh $julday");
	system("/usr/local/bin/matlab -nodesktop -nosplash -r \"testsc('$julday')\"");
	print " finished and waiting 5min\n";
	
}
	

   
sub publishnewindex
{
	my($julianday) = @_;
	#create the new html file by reading the downloaded file and adding header and footer
	open MyFILE, ">", "/media/PABLODISK/privas/Projects/dust/hdf/test/index.htm" or die $!;
	print MyFILE "<html><head><title>Dust Aerosol Automatic Detection - Near Real Time (Orbit Swath) Images</title>\n";
	print MyFILE "<link rel='stylesheet' href='./styles/realtime.css' type='text/css'>\n";
	print MyFILE "<link rel='stylesheet' href='./styles/jquery-ui-1.8.2.custom.css' type='text/css'>\n";
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
	if ($julianday % 2) 
	{
	print MyFILE "<meta http-equiv='REFRESH' content='3;url=https://mspace.utep.edu/privas/web/$julianday/index.html'></head>\n";
	}
	else
	{
	print MyFILE "<meta http-equiv='REFRESH' content='3;url=https://bearspace.baylor.edu/Pablo_Rivas_Perea/www/$julianday/index.htm'></head>\n";
	}
	print MyFILE "<body>\n";
	print MyFILE "Redirecting to the latest information.\n";
	print MyFILE "</body>\n";
	print MyFILE "</html>\n";
	close MyFILE;

	#get list of files to upload
	my $localdir = "/media/PABLODISK/privas/Projects/dust/hdf/test";
	#upload files to baylor
	my($d) = new HTTP::DAV;
	my($url) = {};
	$remotedir={};
	print "\n... Uploading to UTEP\n";
	$url = "https://mspace.utep.edu/privas/web";
	$d->credentials( -user=>"privas",-pass =>"t6emAfre!",-url =>$url);
	$d->open( -url=>$url )
      		or warn("Couldn't open $url: " .$d->message . "\n");
	$remotedir="$url/index.html";
	$d->cwd( -url=>$url );
	if ( $d->put(-local=>"$localdir/index.htm", -url=>$remotedir) ) 
	{
		print "successfully uploaded the main index.htm\n";
	} 
	else 
	{
		print "put failed: " . $d->message . "\n";
	}	
   	$d->unlock( -url => $url );

	print "... Uploading to Baylor\n";
	$url = "https://bearspace.baylor.edu/Pablo_Rivas_Perea/www";
	$d->credentials( -user=>"Pablo_Rivas_Perea",-pass =>"t6emAfre!",-url =>$url);
	$d->open( -url=>$url )
      		or warn("Couldn't open $url: " .$d->message . "\n");
	$remotedir="$url/index.htm";
	$d->cwd( -url=>$url );
	if ( $d->put(-local=>"$localdir/index.htm", -url=>$remotedir) ) 
	{
		print "successfully uploaded the main index.htm\n";
	} 
	else 
	{
		print "put failed: " . $d->message . "\n";
	}	
   	$d->unlock( -url => $url );
}

main();


