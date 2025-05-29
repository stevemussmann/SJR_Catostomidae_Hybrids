#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

# input files
my $p0file = "dx2003_p0in.txt";
my $p1file = "dx2003_p1in.txt";
my $locusfile = "dx2003_loci.txt";

# arrays to hold input
my @p0lines;
my @p1lines;
my @locuslines;

# read in the files
&filetoarray( $p0file, \@p0lines );
&filetoarray( $p1file, \@p1lines );
&filetoarray( $locusfile, \@locuslines );

# hashes
my %p0hash;
my %p1hash;

# get rid of header from @locuslines
shift( @locuslines );

# start locus counter and read $p0file
my $locuscount=0;
my $name;

foreach my $line( @p0lines ){
	if( $line =~ /^locus/ ){
		my $str = $locuslines[$locuscount];
		my @temp = split( /\s+/, $str );
		$name = join( "_", @temp );
		#print $name, "\n";
		$locuscount++;
		$p0hash{$name}{"a0"}=0;
		$p0hash{$name}{"a1"}=0;
	}else{
		my @temp = split( /\s+/, $line );
		$p0hash{$name}{"a0"}+=$temp[0];
		$p0hash{$name}{"a1"}+=$temp[1];
	}
}

# reset locus counter and read $p1file
$locuscount=0;

foreach my $line( @p1lines ){
	if( $line =~ /^locus/ ){
		my $str = $locuslines[$locuscount];
		my @temp = split( /\s+/, $str );
		$name = join( "_", @temp );
		#print $name, "\n";
		$locuscount++;
		$p1hash{$name}{"a0"}=0;
		$p1hash{$name}{"a1"}=0;
	}else{
		my @temp = split( /\s+/, $line );
		$p1hash{$name}{"a0"}+=$temp[0];
		$p1hash{$name}{"a1"}+=$temp[1];
	}
}

foreach my $locus( sort keys %p0hash ){
	#print $locus, "\n";
	#print "p0:\n";
	#print "a0:", $p0hash{$locus}{"a0"}, "\n";
	#print "a1:", $p0hash{$locus}{"a1"}, "\n";
	#print "p1:\n";
	#print "a0:", $p1hash{$locus}{"a0"}, "\n";
	#print "a1:", $p1hash{$locus}{"a1"}, "\n";
	#print "\n";
	if( $p0hash{$locus}{"a0"} == 0 ){
		if( $p1hash{$locus}{"a1"} == 0 ){
			print $locus, "\n";
		}
	}elsif( $p0hash{$locus}{"a1"} == 0 ){
		if( $p1hash{$locus}{"a0"} == 0 ){
			print $locus, "\n";
		}
	}
}

#print Dumper( \@p0lines );
#print Dumper( \%p1hash );

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
		#print $line, "\n";
		push( @$array, $line );
	}

	close FILE;

}

#####################################################################################################
