##----------------------------------------------------------------------------
## :mode=perl:indentSize=2:tabSize=2:noTabs=true:
##----------------------------------------------------------------------------
use Test::More;
use Test::Exception;
use WordSequences;
use Readonly;

## Symbolic constants for various tests
Readonly::Scalar my $TEST_SEQ_LENGTH      => 4;
Readonly::Scalar my $TEST_DATA_WORD_COUNT => 7;
Readonly::Scalar my $UNIQUE_SEQUENCES     => {
  carr => qq{carrots},
  cloc => qq{o'clock},
  give => qq{give},
  lock => qq{o'clock},
  rots => qq{carrots},
  rows => qq{arrows},
  rrot => qq{carrots},
  rrow => qq{arrows},
};

## Test object creation
my $seqs = new_ok(q{WordSequences} => [seq_length => $TEST_SEQ_LENGTH]);

## Test object creation
$seqs = new_ok(q{WordSequences} => [seq_length => $TEST_SEQ_LENGTH]);
cmp_ok($seqs->words_from_file(*DATA),
  qq{==}, $TEST_DATA_WORD_COUNT, qq{Add from filename});

## Build hash reference for comparison
my $got_sequences = {};
foreach my $seq (@{$seqs->unique_sequences})
{
  $got_sequences->{$seq->sequence} = $seq->words->[0];
}

## Compare received with expected hash
is_deeply($got_sequences, $UNIQUE_SEQUENCES, qq{Verify unique sequences});

done_testing();
__END__
arrows
carrots
give
me
100th
O'clock
a.m.