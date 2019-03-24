#!/usr/bin/perl
#
# 
# Packages and modules
#
# 
#

use strict;
use warnings;
use version;         our $VERSION = qv('5.16.0');

my $command;
my $quit = 0;
my $userOp;

system("clear");
print  "Welcome to an analysis of public transportation and education value in Canada. \n";
print  "This program is designed to answer the questions outlined below. \n";
print  "Please enter your choice to begin. \n\n";




while ( $quit == 0 ) {
    print
    "1. What is the average value of public transportation across different provinces between given years?\n",
    "2. How does the value of education in two provinces evolve across a given time period?\n",
    "3. What province has the highest value in education and within that province, what is the percentage of females and males in the various fields of study?\n",
    "4. Quit\n";
    $userOp = <STDIN>;
    chomp $userOp;
    
    if ($userOp eq 1 ) {
        
        $command = system('perl ./Question1/publicTransport.pl ./Question1/bc_on.csv ./Question1/filename.pdf');
        
    }
    
    elsif ($userOp eq 2) {
        
        $command = system('perl ./Question2/q2Script.pl ./Question2/Q2DataFile.csv');
        
    }
    
    elsif ($userOp eq 3) {
        
        $command = system('perl ./Questions3_4/q4Script[4].pl ./Questions3_4/Q4DataFile1.csv ./Questions3_4/Q4DataFile2.csv');
        
    }
    
    elsif ($userOp eq 4) {
        
        $quit = 1;
        
    }
    
    else {
        
        print "Invalid option. Try again: ";
        
    }
    
}