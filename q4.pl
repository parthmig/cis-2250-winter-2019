#!/usr/bin/perl

#
# Programmer: Alanna Tees       ID: 1054823
# Assignment: Team Project      Course: CIS 2250
# Date: March 21, 2019          Version: 3
#
# Program Description: This program calculates the province with the highest value of education.
#                       It then prompts the user to choose a field of study and calculates the percenatges
#                       of male and female students in that field, in the previously discovered province.
#
# Command Line Paramaters:
#       1. File with provinces and education values
#       2. File with information about fields of study and male and female numbers
#

#
#   Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;   # We will be using the CSV module (version 1.32 or higher)
                       # to parse each line

#
#   Variables to be used
#
my $EMPTY = q{};
my $SPACE = q{ };
my $COMMA = q{,};

my $valuesFile = $EMPTY;
my $sexesFile = $EMPTY;

my @values;
my @sexes;

my $valueCount = -1;
my $sexCount = -1;
my $csv = Text::CSV->new({ sep_char => $COMMA });

my @province;
my @valueByProvince;

my @fieldOfStudy;
my @locationOfStudy;
my @totalStudents;
my @maleStudents;
my @femaleStudents;

my $highestValue = 0;
my $valueProvince = "";

my $list = 0;
my $index;
my $percentMale;
my $percentFemale;

#
#   Check that you have the right number of parameters
#
if ($#ARGV != 1 ) {
   print "Usage: q4Script.pl <sexes file> <values file>\n" or
      die "Print failure\n";
   exit;
} else {
   $sexesFile = $ARGV[0];
   $valuesFile = $ARGV[1];
}

#
#   FILE HANDLING
#

#   Open sexes file and read into sexes array
open my $sexes_fh, '<:encoding(UTF-8)', $sexesFile
or die "Unable to open names file: $sexesFile\n";

@sexes = <$sexes_fh>;

close $sexes_fh or
die "Unable to close: $ARGV[0]\n";   # Close sexes file

# Open value file and read into values array
open my $values_fh, '<:encoding(UTF-8)', $valuesFile
   or die "Unable to open names file: $valuesFile\n";

@values = <$values_fh>;

close $values_fh or
   die "Unable to close: $ARGV[1]\n";   # Close values file


#
#   VALUE PARSING
#
foreach my $valueRecord ( @values ) {
   if ( $csv->parse($valueRecord) ) {
      my @valueFields = $csv->fields();

       #print @master_fields, "\n";
       #print $valueFields[0], " ";
       #print $valueFields[1], "\n";

       $valueCount++;
       $province[$valueCount] = $valueFields[0];
       $valueByProvince[$valueCount] = $valueFields[1];
   } else {
      warn "Line/record could not be parsed: $values[$valueCount]\n";
   }
}

foreach my $sexesRecord ( @sexes ) {
    if ( $csv->parse($sexesRecord) ) {
        my @sexFields = $csv->fields();
        
        #print @master_fields, "\n";
        #print $sexes[0], " ";
        #print $sexes[1], "\n";
        
        $sexCount++;
        $fieldOfStudy[$sexCount] = $sexFields[0];
        $locationOfStudy[$sexCount] = $sexFields[1];
        $totalStudents[$sexCount] = $sexFields[2];
        $maleStudents[$sexCount] = $sexFields[3];
        $femaleStudents[$sexCount] = $sexFields[4];
    } else {
        warn "Line/record could not be parsed: $sexes[$sexCount]\n";
    }
}

#
#   OUPUT SETUP AND MENUS PART 1
#
system("clear");
#print "This program will answer which province has the highest value of education.\n";
#print "It will then prompt the user to choose from a list of fields of study and calculate \nthe percentages of males and females in that field.\n";
#print "[Press <RETURN> to continue]\n";
print "Part 1: What province has the highest value of education?\n\n";

#
#   CALCULATE HIGHEST VALUE
#
for my $i (1..$valueCount){
    if($valueByProvince[$i] > $highestValue){
        $valueProvince = $province[$i];
        $highestValue = $valueByProvince[$i];
    }
}
print "The province with the highest value in education is ", $valueProvince, " with a value of ", $highestValue, ".\n";
print "[Press <RETURN> to continue]\n";
my $cont = <STDIN>;
system("clear");

#
#   OUTPUT SETUP AND MENUS PART 2
#
#print "The program will now caculate the perentages of male and female students in a chosen field of study.\n";
#print "From the list below, please enter the number corresponding to the field of study you would like to see.\n";
#print "Enter 0 to exit.\n\n";
print "Part 2: Within that province, what is the percentage of male and female student in each field of study?\n";
print "Please enter an option from the list below to see the percentages corresponding to that field.\n\n";

for my $i (1..$sexCount){
    if($fieldOfStudy[$i] ne $fieldOfStudy[$i-1]){
        $list++;
        print $list, ". ", $fieldOfStudy[$i], "\n";
    }
}
my $choice = 0;
print "\nEnter choice: ";
$choice = <STDIN>;

while($choice < 0 || $choice > 13) {
    print "Invalid choice. Try again: ";
    $choice = <STDIN>;
}
#
#   CALCULATE PERCENTAGES
#
while($choice != 0){
    $index = $choice + (18 * ($choice - 1));
    print "You've chosen ", $fieldOfStudy[$index], ".\n";
    
    for my $i ($index..$index + 17){
        if($locationOfStudy[$i] =~ /^$valueProvince/i){
            $percentMale = $maleStudents[$i] / $totalStudents[$i] * 100;
            $percentFemale = $femaleStudents[$i] / $totalStudents[$i] * 100;
        }
    }
    
    printf "$fieldOfStudy[$index] is %.2f%% male and %.2f%% female.\n\n", $percentMale, $percentFemale;
    
    print "Enter choice: ";
    $choice = <STDIN>;
    while($choice < 0 || $choice > 13) {
        print "Invalid choice. Try again: ";
        $choice = <STDIN>;
    }
}
print "You've chosen to exit.\n";
system('clear');

#
# End script
#