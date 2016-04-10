use warnings;

foreach my $file ( sort glob("*.zip") ) {
	chomp($file);
	my $folder =  $file;
	$folder =~ s/\.zip//g;
   	my $status = `unzip "$file" -d "$folder"`;
	print "Status: ", $status;
	
}
	