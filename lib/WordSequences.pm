package WordSequences;
##----------------------------------------------------------------------------
## :mode=perl:indentSize=2:tabSize=2:noTabs=true:
##****************************************************************************
## NOTES:
##  * Before comitting this file to the repository, ensure Perl Critic can be
##    invoked at the HARSH [3] level with no errors
##****************************************************************************

=head1 NAME

WordSequences - A  Moo based object oriented interface for parsing words into
arbitrary length sequences

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

  use WordSequences;

  my $sequences = WordSequence->new(seq_length => 4);

  ## Load words from a file
  $sequences->words_from_file(qq{dictionary.txt});
  
  ## Print all uniques sequences and their associated word
  foreach my $sequence ($sequences->unique_sequences)
  {
  	printf(qq{%s %s\n}, $sequence->sequence, $sequence->words);
  }

=cut

##****************************************************************************
##****************************************************************************
use Moo;
## Moo enables strictures
## no critic (TestingAndDebugging::RequireUseStrict)
## no critic (TestingAndDebugging::RequireUseWarnings)
use Readonly;
use Carp qw(confess cluck);
use WordSequence;

## Version string
our $VERSION = qq{0.01};

##****************************************************************************
## Object attribute
##****************************************************************************

=head1 ATTRIBUTES

=cut

##****************************************************************************
##****************************************************************************

=head2 seq_length

=over 2

Length of the character sequence

DEFAULT: 4

=back

=cut

##----------------------------------------------------------------------------
has seq_length => (
  is      => qq{rw},
  default => 4,
);

##****************************************************************************
## "Private" attributes
##****************************************************************************
## Hash reference of all sequences
has _sequences => (is => qq{rwp},);

## A list of all words
has _words => (is => qq{rwp},);

##****************************************************************************
## Object Methods
##****************************************************************************

=head1 METHODS

=cut

=for Pod::Coverage BUILD
  This causes Test::Pod::Coverage to ignore the list of subs 
=cut

##----------------------------------------------------------------------------
##     @fn BUILD()
##  @brief Moo calls BUILD after the constructor is complete
##  @param NONE
## @return WordSequence object
##   @note
##----------------------------------------------------------------------------
sub BUILD
{
  my $self = shift;

  ## Create an empty list of words
  $self->_set_words([]);

  return ($self);
}

##****************************************************************************
##****************************************************************************

=head2 add_sequence($sequence, $word)

=over 2

=item B<Description>

Add a sequence to the sequences

=item B<Parameters>

=over 4

=item $sequence

The sequence being added.

=item $word

The source of the sequence

=back 

=item B<Return>

The WordSequence object for the sequence

=back

=cut

##----------------------------------------------------------------------------
sub add_sequence
{
  my $self     = shift;
  my $sequence = shift;
  my $word     = shift;

  ## Validate parameters
  confess(qq{Missing required arguments: sequence}) unless (defined($sequence));
  confess(qq{Missing required arguments: word})     unless (defined($word));

  ## Trim whitespace
  $sequence = _trim($sequence);
  $word     = _trim($word);

  ## Validate length of sequence
  unless ($self->seq_length == length($sequence))
  {
    confess(
      qq{The sequence must be } . $self->seq_length . qq{ characters long!});
  }

  ## See if sequence exists
  if (
    my $seq = $self->_sequences->{$sequence};
    )
  {
    ## Add the word to the sequence
    $seq->add_word($word);
  }
  else
  {
    ## Create a new sequence
    $self->_sequences->{$sequence} =
      WordSequence->new(sequence => $sequence, word => $word);
  }

  ## Return the sequence
  return ($self->_sequences->{$sequence});

}

##****************************************************************************
##****************************************************************************

=head2 words_from_file($param)

=over 2

=item B<Description>

Parse words from the given filename or open filehandle

=item B<Parameters>

=over 4

=item $param

A simple SCALAR containing a filename to open, or an open filehandle to read
from.

=back

=item B<Return>

WordSequence object

=back

=cut

##----------------------------------------------------------------------------
sub words_from_file
{
  my $self  = shift;
  my $param = shift;

  confess(qq{TODO: Implement words_from_file() method});

}

##****************************************************************************
##****************************************************************************

=head2 unique_sequences()

=over 2

=item B<Description>

Return a reference to an array of uniques sequences as L<WordSequence> objects

=item B<Parameters>

=over 4

=item NONE

=back

=item B<Return>

ARRAY refence of WordSequence objects

=back

=cut

##----------------------------------------------------------------------------
sub unique_sequences
{
  my $self  = shift;
  my $param = shift;

  confess(qq{TODO: Implement unique_sequences() method});

}

##----------------------------------------------------------------------------
##     @fn _trim($string)
##  @brief Trim leading and trailing whitespace
##  @param $string - String to trimmed
## @return SCALAR - Trimmed string
##   @note
##----------------------------------------------------------------------------
sub _trim
{
  my $string = shift // qq{};

  $string =~ s/^\s+|\s+$//gx;

  return ($string);
}

##****************************************************************************
## Additional POD documentation
##****************************************************************************

=head1 AUTHOR

Paul Durden E<lt>alabamapaul AT gmail.comE<gt>

=head1 COPYRIGHT & LICENSE

Copyright (C) 2015 by Paul Durden.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;    ## End of module
__END__

