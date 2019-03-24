#!/usr/bin/perl

#
# Author: Parth Miglani         ID: 1047081
# Assignment: Team Project      Course: CIS 2250
# Date: March 21, 2019          Version: 4
#
# Program Description: This program calculates the average of values for public transport for a particular 
#                      province in a given period. It also plots a line graph of the trend in values.
#                
#
# Command Line Paramaters:
#       1. .csv for the province
#       2. .pdf file for the plot
#

#
# Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');
use Text::CSV  1.32;  #Using csv module to parse each line
use Statistics::R;

#
#   Variables to be used
#
my $EMPTY = q{};
my $COMMA = q{,};

my $filename     = $EMPTY;
my $pdf_filename = $EMPTY;
my @records;
my @ref_date;
my @province;
my @value;

my $record_count = 0;
my $value_count = 0;
my $value_total = 0;
my $average = 0;
my $csv          = Text::CSV->new({ sep_char => $COMMA });


#
#   Check that you have the right number of parameters
#
if ($#ARGV != 1 ) {
   print "Usage: publicTransport.pl \n" or
      die "Print failure\n";
   exit;
} else {
   $filename = $ARGV[0];
   $pdf_filename = $ARGV[1];
}

#
# Ask the user for start year, end year, and province
#

my $start_year = 0;
print "Enter the start year: ";
$start_year = <STDIN>;
chomp $start_year;


my $end_year = 0;
print "Enter the end year: ";
$end_year = <STDIN>;
chomp $end_year;


#
#   Open the input file and load the contents into records array
#

open my $cp_index, '<:encoding(UTF-8)', $filename
   or die "Unable to open records file: $filename\n";

@records = <$cp_index>;

close $cp_index or
   die "Unable to close: $ARGV[0]\n";   # Close the input file

#
#   Parse each line and store the information in arrays
#   representing each field
#
#   Extract each field from each name record as delimited by a comma
#

foreach my $public_record ( @records ) {
  if ( $csv->parse($public_record) ) {
      my @master_fields = $csv->fields();
      $ref_date[$record_count] = $master_fields[0];
      $province[$record_count]     = $master_fields[1];
      $value[$record_count]     = $master_fields[2];
      $record_count++;
  } else {
      warn "Line/record could not be parsed: $records[$record_count]\n";
  }
}
$record_count--;

for my $i ( 1..$record_count ) { 

      if ( $ref_date[$i] eq $start_year ) {
         my $j = $i;  
      	while ( $ref_date[$j] ne $end_year) {
            $j++;  
        	   $value[$i]++;
         	$value_total = $value_total + $value[$i];
            if ( $ref_date[$i] eq $end_year ) {
               last;
            }
         }
      }
      $value_count = $value_count + 1;
}

$average = $value_total / $value_count;

my $rounded = sprintf("%.3f", $average);
print "Average of Values is: $rounded \n";

#
# Plot the values
#

# Create a communication bridge with R and start R
my $R = Statistics::R->new();

# Set up the PDF file for plots
$R->run(qq`pdf("$pdf_filename" , paper="letter")`);

# Load the plotting library
$R->run(q`library(ggplot2)`);

# read in data from a CSV file
$R->run(qq`data <- read.csv("$filename")`);

# plot the data as a line plot with each point outlined
#$R->run(q'ggplot(data) + geom_point(aes(Year, Value)) + ggtitle("Value Of Public Transport") + labs(x="Year", y="Value")');
$R->run(q`ggplot(data, aes(x=Year, y=Value, colour=Name, group=Name)) + geom_line() + geom_point(size=2) + ggtitle("Value of Public transport") `);

# close down the PDF device
$R->run(q`dev.off()`);

$R->stop();

#
# End of Script
#