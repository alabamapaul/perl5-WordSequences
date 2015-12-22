##----------------------------------------------------------------------------
## :mode=perl:indentSize=2:tabSize=2:noTabs=true:
##----------------------------------------------------------------------------
use Test::More;
use Test::Exception;
use WordSequences;
use Readonly;

## Symbolic constants for various tests
Readonly::Scalar my $TEST_SEQ_LENGTH  => 3;
Readonly::Scalar my $TEST_SEQ         => qq{ran};
Readonly::Array my @TEST_WORDS        => qw(ran rant random);
Readonly::Array my @TEST_WORDS_SORTED => sort(@TEST_WORDS);

my $seqs;
## Test object creation
$seqs = new_ok(qq{WordSequences});

## Check default length
cmp_ok($seqs->seq_length, qq{==}, 4, qq{Verify default sequence length});

## Test object creation
$seqs = new_ok(q{WordSequences} => [seq_length => $TEST_SEQ_LENGTH]);

## Check default length
cmp_ok($seqs->seq_length, qq{==}, $TEST_SEQ_LENGTH, qq{Verify sequence length});

## Detect missing all aguments
throws_ok { $seqs->add_sequence() } qr/Missing required arguments:\s+sequence/,
  qq{Dies on missing all parameters};

## Detect missing word
throws_ok { $seqs->add_sequence($TEST_SEQ) }
qr/Missing required arguments:\s+word/, qq{Dies on missing word};

## Detect missing incorrect sequence length
throws_ok { $seqs->add_sequence(qq{long}, qq{longer}) }
qr/The sequence must be \d+ characters long/,
  qq{Dies on incorrect sequence length};

## Data for testing add_word() method
Readonly::Array my @ADD_WORD_DATA => (
  { word => qq{at},     count => 0, description => qq{Adding word shorter than sequence length},},
  { word => qq{ran},    count => 1, description => qq{Adding sequence length word},},
  { word => qq{rant},   count => 2, description => qq{Adding word longer than sequence length},},
  { word => qq{random}, count => 4, description => qq{Adding word longer than sequence length},},
);

## Test the add_word() method
foreach my $test (@ADD_WORD_DATA)
{
  cmp_ok($seqs->add_word($test->{word}), qq{==}, $test->{count}, $test->{description});
}

done_testing();
__END__
