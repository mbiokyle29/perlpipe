#!/usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use feature qw|say|;

# Example: bowsaics.pl -d /dir/with/read/ -m EBV -i input -c ebna2chip
my ($read_dir, $map_header, $chip, $input);
GetOptions (
	# Directory with the raw reads (fastq fa fq etc)
	"d=s" => \$read_dir, 

	# Name of the bowtie2 map
	"m=s" => \$map_header,
	
	# Basename (not .fa) of input file
	"i=s" => \$input,
	
	# Basename (not .fa) of chip file
	"c=s" => \$chip,

	# Help
	"h=s" => &useage()
);

my $fp_bowtie2 = "/home/kyle/lab/bowtie2/";
my $fp_results = $fp_bowtie2 . "results/";
$chip .= ".sam";
$input .= ".sam";

# Run the bowtie script
say `perl /home/kyle/lab/perlpipe/perl/bowtie/multi_run.pl -d $read_dir -m $map_header`;

# Move the sams from the bowtie folder to here
move($fp_results.$chip, "./");
move($fp_results.$input, "./");

# Run mosaics
say `perl /home/kyle/lab/perlpipe/perl/mosaics/MosaicsPipe.pl --type IO --format sam --chip $chip --input $input`;

sub useage {
	say "bowsaics.pl - Pipeline script for bowtie2->Mosaics analysis of CHiPSeq data";
	say "-d <directory of reads>";
	say "-m <bowtie map name>";
	say "-i <basename of input file (no .fa)>";
	say "-c <basename of chip file (no .fa)>";
	say "-h print this message";
	say "example: bowsaics.pl -d ~/lab/run123/ -m EBV -i 123_input -c ebna2chip";
	exit;
}