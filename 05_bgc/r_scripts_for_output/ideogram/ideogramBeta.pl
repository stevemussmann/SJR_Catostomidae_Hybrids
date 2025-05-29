#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

my $file = "dx2003_rerun.txt";
my $map = "rbs.chrom.map.txt";

my @fileArray;
my @mapArray;

my %hash;

&filetoarray( $file, \@fileArray );
&filetoarray( $map, \@mapArray );

foreach my $line( @mapArray ){
	my @temp = split( /\t/, $line );
	$hash{$temp[0]} = $temp[1];
}

shift( @fileArray );

my $counter=0;

print "Chr\tStart\tEnd\tValue\n";

foreach my $line( @fileArray ){
	my @temp = split( /\t/, $line );
	#print "$temp[9]\t$temp[10]\n";
	if( ($temp[9] eq "TRUE") or ($temp[10] eq "TRUE") ){
		#print "both true\n";
		#print "$hash{$temp[1]}.b";
		print "$hash{$temp[1]}";
		print "\t";
		print $temp[2];
		print "\t";
		print $temp[2]+100000;
		print "\t";
		print $temp[4];
		print "\n";
	}
}

#print Dumper( \@fileArray );

exit;

#####################################################################################################
# subroutine to put file into an array

sub filetoarray{

	my( $infile, $array ) = @_;
    
	# open the input file
	open( FILE, $infile ) or die "Can't open $infile: $!\n\n";

	# loop through input file, pushing lines onto array
	while( my $line = <FILE> ){
		chomp( $line );
		next if($line =~ /^\s*$/);
		push( @$array, $line );
	}

	# close input file
	close FILE;
}

#####################################################################################################
