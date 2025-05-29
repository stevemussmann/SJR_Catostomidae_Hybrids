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

shift( @fileArray );

foreach my $line( @mapArray ){
	my @temp = split( /\t/, $line );
	$hash{$temp[0]} = $temp[1];
}

my $counter=0;

print "Type\tShape\tChr\tStart\tEnd\tcolor\n";

foreach my $line( @fileArray ){
	my @temp = split( /\t/, $line );
	#print "$temp[9]\t$temp[10]\n";
	if( exists($hash{$temp[1]}) ){
		if( ($temp[9] eq "TRUE") and ($temp[10] eq "TRUE") ){
			#print "both true\n";
			print "both";
			print "\tcircle";
			print "\t";
			print $hash{$temp[1]};
			print "\t";
			print $temp[2];
			print "\t";
			print $temp[2];
			print "\t";
			print "6a3d9a";
			print "\n";
		}else{
			if( $temp[9] eq "TRUE" ){
				#print "alpha true\n";
				print "alpha";
				print "\ttriangle";
				print "\t";
				print $hash{$temp[1]};
				print "\t";
				print $temp[2];
				print "\t";
				print $temp[2];
				print "\t";
				print "33a02c";
				print "\n";
			}elsif( $temp[10] eq "TRUE" ){
				#print "beta true\n";
				print "beta";
				print "\tbox";
				print "\t";
				print $hash{$temp[1]};
				print "\t";
				print $temp[2];
				print "\t";
				print $temp[2];
				print "\t";
				print "ff7f00";
				print "\n";
			#}else{
			#	print "non-outlier";
			#	print "\tcircle";
			#	print "\t";
			#	print $hash{$temp[1]};
			#	print "\t";
			#	print $temp[2];
			#	print "\t";
			#	print $temp[2];
			#	print "\t";
			#	print "899499";
			#	print "\n";
			}
		}
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
