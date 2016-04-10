use warnings;

print ("Now Sorting \n");

$file="combine.csv";
use Data::Dumper;
my ( %data1, %data2 );

    open my $fh, "<", $file or die $!;

	my $count=0;
    while ( my $line = <$fh> ) {
		$count++;
        chomp $line;
		next if ($line =~ /^User*/);
		next if ($line =~ /^$/);
        my @values = split /,/, $line;
		my ($username, $date, $time) = ($values[0], $values[4], $values[5]);
		#sleep(1);
		$date =~ s/"//g;
		$time =~ s/"//g;
		if (exists $data1{$date}){
		push @{$data1{$date}}, $username;
		}
		else{
		$data1{$date}=[$username];
		}
		if (exists $data2{$date}{$time}){
		push @{$data2{$date}{$time}}, $username;
		}
		else{
		$data2{$date}{$time}=[$username];
		}
		
	


}
	

close $fh;

# write result to a file

open(RESULTS1,'>','results1.txt') or die $!;
open(RESULTS2,'>','results2.txt') or die $!;
foreach my $date ( sort keys %data1 ) {
	
	my $size1 = scalar @{$data1{$date}};
    print RESULTS1 $date, "----", "count: ", $size1, "\n";
	

	foreach my $time ( sort keys %{$data2{$date}} ) {
		my $size2 = scalar @{$data2{$date}{$time}};
		print RESULTS2 $date, ",", $time, "---- ", "count: ", $size2, "\n";
	
}
}
close(RESULTS1);
close(RESULTS2);

