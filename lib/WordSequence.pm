package WordSequence;
##----------------------------------------------------------------------------
## :mode=perl:indentSize=2:tabSize=2:noTabs=true:
##****************************************************************************
## NOTES:
##  * Before comitting this file to the repository, ensure Perl Critic can be
##    invoked at the HARSH [3] level with no errors
##****************************************************************************

=head1 NAME

WordSequence - Object for recording words with an arbitrary sequence length 

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

  use WordSequence;

  my $sequence = WordSequence->new(sequence => qq{appl}, word => qq{apple});


=cut

##****************************************************************************
##****************************************************************************
use Moo;
## Moo enables strictures
## no critic (TestingAndDebugging::RequireUseStrict)
## no critic (TestingAndDebugging::RequireUseWarnings)
use Readonly;
use Carp qw(confess);

## Version string
our $VERSION = qq{0.01};

##****************************************************************************
## Object attribute
##****************************************************************************

=head1 ATTRIBUTES

=cut

##****************************************************************************
##****************************************************************************

=head2 sequence

=over 2

Arbitrary length of characters

=back

=cut

##----------------------------------------------------------------------------
has sequence => (
  is       => qq{rw},
  required => 1,
);

##****************************************************************************
##****************************************************************************

=head2 count

=over 2

Number of words added to the sequence.

B<NOTE:> The number of count may not equal the number of words returned by
the words() method as count is incremented when duplicate words are added.


=back

=cut

##----------------------------------------------------------------------------
has count => (
  is      => qq{rw},
  default => 0,
);

##****************************************************************************
## "Private" attributes
##****************************************************************************
## A hash of all words
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
  my $self = shift; ## Object
  my $args = shift; ## Hash ref of arguments to new()
  
  ## Create an empty list of words
  $self->_words({});
  
  ## Make sure we received a word
  confess(qq{Missing required arguments: word}) unless ($args->{word});
  
  ## Add the word
  $self->add_word($args->{word});

  return ($self);
}

##****************************************************************************
##****************************************************************************

=head2 add_word($word)

=over 2

=item B<Description>

Add a word for the sequence

=item B<Parameters>

=over 4

=item $word

Word that containes the sequence

=back

=item B<Return>

Number of occurences of the added word in the sequence

=back

=cut

##----------------------------------------------------------------------------
sub add_word
{
  my $self = shift;
  my $word = shift;
  
  confess(qq{The word parameter is required!}) unless (defined($word));
  
  $self->count($self->count + 1);
  $self->_words->{$word}++;
  
  ## Return the number of times the word has been added
  return($self->_words->{$word});
}

##****************************************************************************
##****************************************************************************

=head2 words()

=over 2

=item B<Description>

Return a reference to an array of words for this sequence

=item B<Parameters>

=over 4

=item NONE

=back

=item B<Return>

ARRAY refence of SCALARS containing the words for this sequence

=back

=cut

##----------------------------------------------------------------------------
sub words
{
  my $self = shift;
  
  return([keys(%{$self->_words})]);
}

##****************************************************************************
##****************************************************************************

=head2 is_unique()

=over 2

=item B<Description>

Returns a true value if this sequence has only been added once (i.e. count is 0)

=item B<Parameters>

=over 4

=item NONE

=back

=item B<Return>

TRUE value if count is 0

=back

=cut

##----------------------------------------------------------------------------
sub is_unique
{
  my $self = shift;
  
  return(($self->count == 1) ? 1 : 0);
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

