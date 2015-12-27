#!/usr/bin/perl -w
##----------------------------------------------------------------------------
## :mode=perl:indentSize=2:tabSize=2:noTabs=true:
##----------------------------------------------------------------------------
##        File: word_sequences.pl
## Description: Parse file into arbitrary length of unique sequences
##----------------------------------------------------------------------------
use strict;
use warnings;
use 5.010;
## Cannot use Find::Bin because script may be invoked as an
## argument to another script, so instead, use __FILE__
use File::Basename;
use File::Spec;
## Add script directory
use lib File::Spec->catdir(
  File::Spec->splitdir(File::Basename::dirname(__FILE__)));
## Add script directory/lib
use lib File::Spec->catdir(
  File::Spec->splitdir(File::Basename::dirname(__FILE__)), qq{lib});
## Add script directory/../lib
use lib File::Spec->catdir(
  File::Spec->splitdir(File::Basename::dirname(__FILE__)), qw(.. lib));
use Getopt::Long;
use Pod::Usage;
use Readonly;
use Cwd qw(abs_path);
use WordSequences;

##--------------------------------------------------------
## Symbolic Constants
##--------------------------------------------------------
Readonly::Scalar our $VERSION => qq{0.02};

##--------------------------------------------------------
## A list of all command line options
## For GetOptions the following parameter indicaters are used
##    = Required parameter
##    : Optional parameter
##    s String parameter
##    i Integer parameter
##    f Real number (float)
## If a paramer is not indicated, then a value of 1
## indicates the parameter was found on the command line
##--------------------------------------------------------
Readonly::Scalar my $COMMAND_LINE_OPTIONS => [
  qq{words=s},
  qq{sequences=s},
  qq{input=s},
  qq{length=i},
  qq{unique!},
  qq{help},
  qq{man},
  qq{version},
  qq{debug},
];

## Global options
my $gOptions = {
  words     => qq{words},
  sequences => qq{sequences},
  unique    => 1,
  length    => 4,
};

##----------------------------------------------------------------------------
##     @fn process_commandline($options, $options_specifier, $allow_extra_args)
##  @brief Process all the command line options
##  @param $options - HASH reference for parsed command line options
##  @param $options_specifier - Array reference of possible command line
##            options
##  @param $allow_extra_args - If TRUE, leave any unrecognized arguments in
##            @ARGV. If FALSE, consider unrecognized arguements an error.
##            (DEFAULT: FALSE)
## @return NONE
##   @note
##----------------------------------------------------------------------------
sub process_commandline
{
  my $options           = shift;
  my $options_specifier = shift;
  my $allow_extra_args  = shift;

  ## Pass through un-handled options in @ARGV
  Getopt::Long::Configure("pass_through");
  GetOptions($options, @{$options_specifier});

  ## See if --man was on the command line
  if ($options->{man})
  {
    pod2usage(
      -input    => \*DATA,
      -message  => "\n",
      -exitval  => 1,
      -verbose  => 99,
      -sections => '.*',     ## ALL sections
    );
  }

  ## See if --help was on the command line
  display_usage_and_exit(qq{}) if ($options->{help});

  ## See if --version was on the command line
  if ($options->{version})
  {
    print(version_string(), qq{\n});
    exit(1);
  }

  ## See if there were any unknown parameters on the command line
  if (@ARGV && !$allow_extra_args)
  {
    display_usage_and_exit("\n\nERROR: Invalid "
        . (scalar(@ARGV) > 1 ? "arguments" : "argument") . ":\n  "
        . join("\n  ", @ARGV)
        . "\n\n");
  }

  return;
}

##----------------------------------------------------------------------------
##    name display_usage_and_exit($message, $exitval)
##   brief Display the usage with the given message and exit with the given
##         value
##   param $message - Message to display. DEFAULT: ""
##   param $exitval - Exit vaule DEFAULT: 1
##  return NONE
##   @note
##----------------------------------------------------------------------------
sub display_usage_and_exit
{
  my $message = shift // qq{};
  my $exitval = shift // 1;

  pod2usage(
    -input   => \*DATA,
    -message => $message,
    -exitval => $exitval,
    -verbose => 1,
  );

  return;
}

##----------------------------------------------------------------------------
##     @fn validate_parameters($options)
##  @brief Validate the command line parameters
##  @param $options - HASH reference for parsed command line options
## @return NONE
##   @note 
##----------------------------------------------------------------------------
sub validate_parameters
{
  my $options = shift // {};
  
  # Verify input file exists (if specified)
  if ($options->{input} and (!-f qq{$options->{input}}))
  {
    display_usage_and_exit(
      qq{\n\nERROR: Could not locate input file "$options->{input}"\n});
  }
  
  ## Make sure --length is 
  if ($options->{length} <= 0)
  {
    display_usage_and_exit(
      qq{\n\nERROR: The --length parameter must be a positive number!\n});
  }
  
  return;
}

##----------------------------------------------------------------------------
##     @fn version_string()
##  @brief Return a string with the script filename with the version number
##  @param NONE
## @return SCALAR - version string 
##   @note 
##----------------------------------------------------------------------------
sub version_string
{
  return(File::Basename::basename(__FILE__) . qq{ v$VERSION});
}

##----------------------------------------------------------------------------
## MAIN
##----------------------------------------------------------------------------
## Set STDOUT to autoflush
$| = 1;   ## no critic (RequireLocalizedPunctuationVars)

## Parse the command line
process_commandline($gOptions, $COMMAND_LINE_OPTIONS);

## Validate various command lin parameters
validate_parameters($gOptions);

## Display header
print(qq{#} x 70, qq{\n});
print(qq{## }, version_string(), qq{\n});
print(qq{##}, qq{-} x 68, qq{\n});
print(qq{## Sequences filename: "$gOptions->{sequences}"\n});
print(qq{## Sequence length:    $gOptions->{length}\n});
print(qq{## Word filename:      "$gOptions->{words}"\n});
print(qq{## Input filename:     },($gOptions->{input} ? qq{"$gOptions->{input}"} : qq{STDIN}), qq{\n}); 
print(qq{#} x 70, qq{\n});

## Create the WordSequence object
my $seqs = WordSequences->new(seq_length => $gOptions->{length});

## Determine where to read input
if ($gOptions->{input})
{
  ## Filename was specified
  $seqs->words_from_file($gOptions->{input});
}
else
{
  ## No --input option, so use STDIN
  $seqs->words_from_file(*STDIN);
}

## Open the output files
my $fh = {};
foreach my $which (qw(words sequences))
{
  unless (open($fh->{$which}, qq{>}, $gOptions->{$which}))
  {
    die(qq{ERROR: Could not open $which file "$gOptions->{$which}" - $!\n});
  }
}

## Determine sequences to output
my $sequences = ($gOptions->{unique} ? $seqs->unique_sequences : $seqs->all_sequences);
foreach my $seq (@{$sequences})
{
  print {$fh->{words}} (join(qq{ }, @{$seq->words}), qq{\n});
  print {$fh->{sequences}} ($seq->sequence, qq{\n});
}

## Close the output files
close($_) foreach (values(%{$fh}));

exit(0);

__END__

__DATA__

##----------------------------------------------------------------------------
## By placing the POD in the DATA section, we can use
##   pod2usage(input => \*DATA)
## even if the script is compiled using PerlApp, perl2exe or Perl::PAR
##----------------------------------------------------------------------------

=head1 NAME

word_sequences.pl - Examine the input file and generate a sequence and word
file.

=head1 SYNOPSIS

B<word_sequences.pl> 
{B<--unique> | B<--no-unique>}
{B<--length> I<SequenceLength>}
{B<--input> I<InputFilename>}
{B<--words> I<WordsFilename>}
{B<--sequences> I<SequencesFilename>}
{B<--help>}
  
=head1 OPTIONS

=over 4

=item B<--unique> | B<--no-unique>

Specify if only unique sequences (--unique) or all sequences (--no-unique) 
should be written to the "words" and "sequences" output files.

DEFAULT: --unique

=item B<--length> I<SequenceLength>

Specify the length of the sequence.

DEFAULT: --length 4

=item B<--input> I<InputFilename>

Specify the input filename. If none is specified, input will be read from 
STDIN

=item B<--words> I<WordsFilename>

Specify the the name of the "words" output file.  Each line in the "words"
file indicates the word (or words if --no-unique is specified) that contains
the sequence on the same line number in the "sequences" file. 

DEFAULT: --words "words"

=item B<--sequences> I<SequencesFilename>

Specify the the name of the "sequences" output file.  Each line in the 
"sequences" file contains a sequnce of the specified length and the word
(or words if --no-unique is specified) that contains the sequence is on the
same line number in the "words" file.

DEFAULT: --sequences "sequences"

=item B<--version>

Print version information and exit.

=item B<--help>

Display basic help.

=item B<--man>

Display more detailed help.

=back

=head1 DESCRIPTION

word_sequences.pl generates a list of sequences of the specified length.

=cut

