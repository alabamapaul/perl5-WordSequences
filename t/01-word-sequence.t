##----------------------------------------------------------------------------
## :mode=perl:indentSize=2:tabSize=2:noTabs=true:
##----------------------------------------------------------------------------
use Test::More;
use Test::Exception;
use WordSequence;
use Readonly;

## Symbolic constants for various tests
Readonly::Scalar my $TEST_SEQ         => qq{ran};
Readonly::Array my @TEST_WORDS        => qw(ran rant random);
Readonly::Array my @TEST_WORDS_SORTED => sort(@TEST_WORDS);

my $seq;

## Detect missing all aguments
throws_ok { $seq = WordSequence->new() }
qr/Missing required arguments:\s+sequence/, qq{Dies on missing all parameters};

## Detect missing sequence agument
throws_ok { $seq = WordSequence->new(word => $TEST_WORDS[0]) }
qr/Missing required arguments:\s+sequence/, qq{Dies on missing sequence};

## Detect missing word agument
throws_ok { $seq = WordSequence->new(sequence => $TEST_SEQ) }
qr/Missing required arguments:\s+word/, qq{Dies on missing word};

## Adding a word
$seq =
  new_ok(qq{WordSequence} => [sequence => $TEST_SEQ, word => $TEST_WORDS[0]]);

## Check counts
is($seq->count, 1, qq{Count correct after creation});
ok($seq->is_unique, qq{Sequence is unique after creation});

## Check words returned
my @words;
@words = sort(@{$seq->words});
cmp_ok(scalar(@words), qq{==}, 1, qq{Returned 1 word after creation})
  or diag(explain(@words));

## Add a duplicate word
$seq->add_word($TEST_WORDS[0]);

## Check counts
is($seq->count, 2, qq{Count after adding duplicate});
ok(!$seq->is_unique, qq{Sequence is not unique after adding duplicate});

## Check words returned
@words = sort(@{$seq->words});
cmp_ok(scalar(@words), qq{==}, 1, qq{Returned 1 word after creation})
  or diag(explain(@words));

## Add all the words
my $expected_count = $seq->count + scalar(@TEST_WORDS);
$seq->add_word($_) foreach (@TEST_WORDS);

## Check counts
is($seq->count, $expected_count, qq{Count after adding all words});

## Check words returned
@words = sort(@{$seq->words});
is_deeply(\@words, \@TEST_WORDS_SORTED, qq{Returned expected words});

done_testing();
