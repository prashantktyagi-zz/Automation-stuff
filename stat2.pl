use warnings;

print ("Now Sorting \n");

$file="combine.csv";
use Data::Dumper;
my ( %data1, %data2 );
my @new_host_user;
my @unique_users;
my (@ccm1users, @ccm2users, @ccm3users, @ccm4users);

    open my $fh, "<", $file or die $!;

	my $count=0;
    while ( my $line = <$fh> ) {
		$count++;
        chomp $line;
		next if ($line =~ /^User*/);
		next if ($line =~ /^$/);
        my @values = split /,/, $line;
		my ($username, $hostname, $date, $time) = ($values[0], $values[1], $values[4], $values[5]);
		#sleep(1);
		$date =~ s/"//g;
		$time =~ s/"//g;
		chomp($hostname);
		push @unique_users, $username if not ($username ~~ @unique_users);
		push @new_host_user, "$username : $hostname" if not ($hostname =~ /s619784shvl27.ukslou1.savvis.net/);

		if (exists $data1{$date}){
		push @{$data1{$date}}, $username if not ($username ~~ @{$data1{$date}});
		}
		else{
		$data1{$date}=[$username];
		}
		if (exists $data2{$date}{$time}){
		push @{$data2{$date}{$time}}, $username if not ($username ~~ @{$data2{$date}{$time}});
		}
		else{
		$data2{$date}{$time}=[$username];
		}


}
	

close $fh;

foreach my $filename ( sort glob("*.csv") ) {

next if ( $filename =~ /combine/);

    open my $fh2, "<", $filename or die $!;

	my $count=0;
	my ($project, $username, $userid, $role);
    while ( my $line = <$fh2> ) {
		$count++;
        chomp $line;
		next if ($line =~ /^Project*/);
		next if ($line =~ /^$/);
        my @values = split /,/, $line;
		($project, $username, $userid, $role) = ($values[0], $values[1], $values[3], $values[4]) if ($filename =~ /userlist/);
		($project, $username, $userid) = ($values[0], $values[1], $values[3]) if ($filename =~ /adminlist/);
		if ($filename =~ /ccm1/){
		push @ccm1users, $userid if not ($userid ~~ @ccm1users);
		}
		elsif ($filename =~ /ccm2/){
		push @ccm2users, $userid if not ($userid ~~ @ccm2users);
		}
		elsif ($filename =~ /ccm3/){
		push @ccm3users, $userid if not ($userid ~~ @ccm3users);
		}
		elsif ($filename =~ /ccm4/){
		push @ccm4users, $userid if not ($userid ~~ @ccm4users);
		}
		else
		{ # do nothning
		}
	}

close $fh2;
}

# write result to a file

open(RESULTS1,'>','resultsuser1.txt') or die $!;
open(RESULTS2,'>','resultsuser2.txt') or die $!;
open(RESULTS3,'>','ccmreport.txt') or die $!;
print RESULTS1 "\n", "***********************", " User with different hostname ", "**************************", "\n\n";
foreach (@new_host_user){
	print RESULTS1 $_, "\n";
}

print RESULTS1 "\n", "***********************", " Unique Users ", "Total count:- ", scalar(@unique_users), "  ", "**************************", "\n\n";
foreach (@unique_users){
	print RESULTS1 $_, "\n";
}
print RESULTS3 "\n\n", "*********************", "CCM report", "**************************", "\n\n";
print RESULTS3 "  ", "Date    ", "CCM1  ", "CCM2 ", "CCM3  ", "CCM4  ", "Non CCM", "\n";
foreach my $date ( sort keys %data1 ) {

	my @arr1 =  @{$data1{$date}};
	my $totalusercount1 = scalar @arr1;
	my $ccm1counter = 0;
	my $ccm2counter = 0;
	my $ccm3counter = 0;
	my $ccm4counter = 0;
	my $restcounter =0;
	foreach my $element (@arr1){
		
		
		$ccm1counter++ if ( $element ~~ @ccm1users) ;
		$ccm2counter++ if ( $element ~~ @ccm2users);
		$ccm3counter++ if ( $element ~~ @ccm3users);
		$ccm4counter++ if ( $element ~~ @ccm4users);
		$restcounter++ if not ($element ~~ @ccm1users || $element ~~ @ccm2users || $element ~~ @ccm3users || $element ~~ @ccm4users);
		push @non_ccm_users, $element if not ($element ~~ @ccm1users || $element ~~ @ccm2users || $element ~~ @ccm3users || $element ~~ @ccm4users);
	
		
	}
	my $ccm1 = ($ccm1counter/$totalusercount1)*100;
	$ccm1 =  int $ccm1;
	my $ccm2 = ($ccm2counter/$totalusercount1)*100;
	$ccm2 =  int $ccm2;
	my $ccm3 = ($ccm3counter/$totalusercount1)*100;
	$ccm3 = int $ccm3;
	my $ccm4 = ($ccm4counter/$totalusercount1)*100;
	$ccm4 =  int $ccm4;
	my $non_ccm = ($restcounter/$totalusercount1)*100;
	$non_ccm =  int $non_ccm;
	
	
	print RESULTS3 " ", $date;
	print RESULTS3 "  ", $ccm1, "%";
	print RESULTS3 "    ", $ccm2, "%";
	print RESULTS3 "   ", $ccm3, "%";
	print RESULTS3 "    ", $ccm4, "%";
	print RESULTS3 "    ", $non_ccm, "%", "\n";
	#print RESULTS3 "\n\n", "********", "Non CCM users", "**************", "\n \n";
	#foreach (@non_ccm_users){
		#print RESULTS3 $_, "\n";
	#}

    print RESULTS1 "\n\n", "*********************", "Date:- ", $date, " Total count:- ", $totalusercount1, " - Unique User list", "**************************", "\n\n";

		foreach (@arr1){
			print RESULTS1 $_, "\n";
			}
	

	foreach my $time ( sort keys %{$data2{$date}} ) {
		my @arr2 =  @{$data2{$date}{$time}};
		my $totalusercount2 = scalar @arr2;
		print RESULTS2 "\n\n", "*********************", "Date:- ", $date, " & Time:- ", $time, " Total count:- ", $totalusercount2, " - Unique User list", "**************************", "\n\n";
			
			foreach (@arr2){
			print RESULTS2 $_, "\n";
			}
}

}
close(RESULTS1);
close(RESULTS2);
close(RESULTS3);

