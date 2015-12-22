##----------------------------------------------------------------------------
## :mode=perl:indentSize=2:tabSize=2:noTabs=true:
##----------------------------------------------------------------------------
use Test::More;
use Test::Exception;
use WordSequences;
use Readonly;

## Symbolic constants for various tests
Readonly::Scalar my $TEST_SEQ         => qq{ran};
Readonly::Array my @TEST_WORDS        => qw(ran rant random);
Readonly::Array my @TEST_WORDS_SORTED => sort(@TEST_WORDS);

my $seqs;
## Test object creation
$seqs = new_ok(q{WordSequences});

## Check default length
cmp_ok($seqs->seq_length, qq{==}, 4, qq{Verify default sequence length});

## Test object creation
$seqs = new_ok(q{WordSequences} => [seq_length => 3]);

## Check default length
cmp_ok($seqs->seq_length, qq{==}, 3, qq{Verify sequence length});

## Detect missing all aguments
throws_ok { $seqs->add_sequence() }
qr/Missing required arguments:\s+sequence/, qq{Dies on missing all parameters};

## Detect missing word
throws_ok { $seqs->add_sequence($TEST_SEQ) }
qr/Missing required arguments:\s+word/, qq{Dies on missing word};

## Detect missing incorrect sequence length
throws_ok { $seqs->add_sequence(qq{long}, qq{longer}) }
qr/The sequence must be \d+ characters long/, qq{Dies on incorrect sequence length};

done_testing();
__END__

__DATA__
supple
supplant
plant
planted
plants
