#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Std;
use Data::Dumper;

# kill program and print help if no command line arguments were given
if( scalar( @ARGV ) == 0 ){
  &help;
  die "Exiting program because no command line options were used.\n\n";
}

# take command line arguments
my %opts;
getopts( 'hf:m:o:', \%opts );

# if -h flag is used, or if no command line arguments were specified, kill program and print help
if( $opts{h} ){
  &help;
  die "Exiting program because help flag was used.\n\n";
}

# parse the command line
my( $file, $map, $out ) = &parsecom( \%opts );

my @fileLines;
my @mapLines;

my %hash;

&filetoarray( $file, \@fileLines );
&filetoarray( $map, \@mapLines );

foreach my $line( @mapLines ){
	my @temp = split( /\t/, $line );
	$hash{$temp[0]} = $temp[1];
}

open( OUT, '>', $out ) or die "Can't open $out: $!\n\n";
foreach my $line( @fileLines ){
	my @temp = split( /\t/, $line );
	push( @temp, $hash{$temp[1]} );
	my $newstring = join( "\t", @temp );
	print OUT $newstring, "\n";
}

close OUT;

exit;

#####################################################################################################
############################################ Subroutines ############################################
#####################################################################################################

# subroutine to print help
sub help{
  
  print "\naddSpecies.pl is a perl script developed by Steven Michael Mussmann\n\n";
  print "To report bugs send an email to mussmann\@email.uark.edu\n";
  print "When submitting bugs please include all input files, options used for the program, and all error messages that were printed to the screen\n\n";
  print "Program Options:\n";
  print "\t\t[ -h | -f | -m | -o ]\n\n";
  print "\t-h:\tDisplay this help message.\n";
  print "\t\tThe program will die after the help message is displayed.\n\n";
  print "\t-f:\tSpecify the name of the input BLAST results file (tabular format).\n\n";
  print "\t-m:\tSpecify the name of the species map file.\n\n";
  print "\t-o:\tSpecify output file (Optional).\n\n";
  
}

#####################################################################################################
# subroutine to parse the command line options

sub parsecom{ 
  
  my( $params ) =  @_;
  my %opts = %$params;
  
  # set default values for command line arguments
  my $file = $opts{f} || die "No BLAST results file specified.\n\n"; #used to specify input file name.
  my $map = $opts{m} || die "No species map file specified.\n\n"; #used to specify input file name.
  my $out = $opts{o} || "blast.species.out.txt"; #used to specify output file name.

  return( $file, $map, $out );

}

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
