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

Version 0.03

=head1 SYNOPSIS

  use WordSequences;

  my $sequences = WordSequence->new(seq_length => 4);

  ## Load words from a file
  $sequences->words_from_file(qq{dictionary.txt});
  
  ## Print all uniques sequences and their associated word
  foreach my $sequence ($sequences->unique_sequences)
  {
    printf(qq{%s %s\n}, $sequence->sequence, join(qq{ }, $sequence->words));
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
use Scalar::Util qw(openhandle);

## Version string
our $VERSION = qq{0.03};

##****************************************************************************
## Object attribute
##****************************************************************************

=head1 ATTRIBUTES

=cut

##****************************************************************************
##****************************************************************************

=head2 seq_length

=over 2

Length of the letter sequence

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
has _sequences => (is => qq{rw},);

## A list of all words
has _words => (is => qq{rw},);

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
  $self->_words([]);
  
  ## Create an empty hash for sequences
  $self->_sequences({});

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
  if (my $seq = $self->_sequences->{$sequence})
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

=head2 add_word($word)

=over 2

=item B<Description>

Add all possible sequences from the given word

=item B<Parameters>

=over 4

=item $word

Word to be processed

=back

=item B<Return>

A count of the number of sequences extracted from the word

=back

=cut

##----------------------------------------------------------------------------
sub add_word
{
  my $self = shift;
  my $word = shift;
  
  ## Validate parameters
  confess(qq{Missing required arguments: word}) unless (defined($word));
  
  ## Trim whitespace
  $word = _trim(lc($word));
  
  ## Skip words that are shorter than the sequence length
  return(0) if (length($word) < $self->seq_length);
  
  ## Determine number of sequences
  my $count = length($word) - $self->seq_length + 1;
  
  ## Number of sequences added
  my $added = 0;
  
  ## Extract all sequences
  for (my $start = 0; $start < $count; $start++)
  {
    my $seq = substr($word, $start, $self->seq_length);
    ## Skip any sequence that has any thing that is not a letter a-z 
    next if ($seq =~ /[^a-z]+/x);
    ## Increment the count
    $added++;   
    ## Add the sequence
    $self->add_sequence($seq, $word);
  }

  ## Return the number of sequences extracted
  return($added);
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

The number of words processed

=back

=cut

##----------------------------------------------------------------------------
sub words_from_file
{
  my $self  = shift;
  my $param = shift;

  ## Validate parameters
  confess(qq{qq{Missing required arguments: file}}) unless (defined($param));
  
  my $fh;         ## Filehandle
  my $close_fh;   ## Flag indicating if we need to call close()
  my $count = 0;  ## Number of words processed
  
  ## See if we received a filehandle
  if (openhandle($param))
  {
    ## Received an open filehandle
    $fh = $param;
  }
  else
  {
    ## Assume we received a filename
    confess(qq{Could not open file "$param"}) unless (open($fh, qq{<}, $param));
    ## Set flag to close file
    $close_fh = 1;
  }
  
  ## Read the file
  while (my $line = <$fh>)
  {
    foreach my $word (split(/\s+/x, $line))
    {
      $word = _trim($word);
      next unless($word);
      $count++;
      $self->add_word($word);
    }
  }
  close($fh) if ($close_fh);

  ## Return number of words processed
  return($count);
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
  my $self = shift;
  my $list = [];

  foreach my $seq (sort(keys(%{$self->_sequences})))
  {
    my $obj = $self->_sequences->{$seq};
    push(@{$list}, $obj) if ($obj->is_unique); 
  }
  
  return($list);
  
}

##****************************************************************************
##****************************************************************************

=head2 all_sequences()

=over 2

=item B<Description>

Return a reference to an array of all sequences as L<WordSequence> objects

=item B<Parameters>

=over 4

=item NONE

=back

=item B<Return>

ARRAY refence of WordSequence objects

=back

=cut

##----------------------------------------------------------------------------
sub all_sequences
{
  my $self = shift;
  my $list = [];

  foreach my $seq (sort(keys(%{$self->_sequences})))
  {
    push(@{$list}, $self->_sequences->{$seq}); 
  }
  
  return($list);
  
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

