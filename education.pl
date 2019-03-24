#!/usr/bin/perl
#
#   Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;
use Statistics::R;      # We will be using the CSV module (version 1.32 or higher)
                        # to parse each line

#   Variables to be used

my $EMPTY = q{};
my $SPACE = q{ };
my $COMMA = q{,};

my $education_file     = $EMPTY;
my $start_year;
my $end_year;
my $province1;
my $province2;

my $name_record;
my $edu_records;
my $record_count       = -1;

my @value;
my @records;
my @date;
my @province;

my $csv                = Text::CSV->new({ sep_char => $COMMA });

#
#   Checking for the right number of parameters
#

if ($#ARGV != 0 ) {
   print "Usage: <start_year> <end_year>\n" or
      die "Print failure\n";
   exit;
} else {
   $education_file     = $ARGV[0];
}

#
#   Open the name file (last parameter) and load the contents into records array
#
open my $education_fh, '<:encoding(UTF-8)', $education_file
  or die "Unable to open file: $education_file\n";

@records = <$education_fh>;

close $education_fh, or
die "Unable to close: $education_file\n";

#   Extract each field from each name record as delimited by a comma

my $i = 0;
# print $records[$i];
foreach my $education_records ( @records ) {
    $record_count++;

       if ( $csv->parse($education_records) ) {
          my @master_fields = $csv->fields();
          $date[$record_count]         = $master_fields[1];
          $province[$record_count]     = $master_fields[0];
          $value[$record_count]        = $master_fields[2];
      } else {
          warn "Line/record could not be parsed: $name_record\n";
      }
}


print "Enter the first province that you're interested in: ";
$province1 = <STDIN>;
chomp ($province1);

print "Enter the second province that you're interested in comparing to: ";
$province2 = <STDIN>;
chomp ($province2);

print "Enter the desired start year: ";
$start_year = <STDIN>;
chomp ($start_year);

print "Enter the desired end year: ";
$end_year = <STDIN>;
chomp ($end_year);

my $filename = 'plotData.csv';
open(my $fh, '>', $filename)
    or die "Could not open file $filename\n";

print $fh "Province, Year, Value\n";

for my $c (0..$record_count)
{
    if (($province[$c] =~ /$province1/i) && ($date[$c] >= $start_year && $date[$c] <= $end_year))
    {
        print $fh $province1, ",", $date[$c], ",", $value[$c], "\n";
    }
    if (($province[$c] =~ /$province2/i) && ($date[$c] >= $start_year && $date[$c] <= $end_year))
    {
        print $fh $province2, ",", $date[$c], ",", $value[$c], "\n";
    }
}

close $fh;
print "done\n";

my $R = Statistics::R->new();
$R->run(qq`pdf("plot.pdf" , paper="letter")`);
$R->run(q`library(ggplot2)`);
$R->run(qq`data <- read.csv("plotData.csv")`);
$R->run(q`ggplot(data, aes(x=Year, y=Value, colour=Province, group=Province)) + geom_line() + geom_point(size=2) + ggtitle("Value Trends")`);
$R->run(q`dev.off()`);
$R->stop();

