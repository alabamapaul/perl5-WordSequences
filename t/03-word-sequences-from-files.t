##----------------------------------------------------------------------------
## :mode=perl:indentSize=2:tabSize=2:noTabs=true:
##----------------------------------------------------------------------------
use Test::More;
use Test::Exception;
use WordSequences;
use Readonly;
use File::Spec;
use File::Basename qw(dirname);

## Symbolic constants for various tests
Readonly::Scalar my $TEST_SEQ_LENGTH      => 4;
Readonly::Scalar my $TEST_FILE_WORD_COUNT => 4;

## Test object creation
my $seqs = new_ok(q{WordSequences} => [seq_length => $TEST_SEQ_LENGTH]);

cmp_ok($seqs->words_from_file(*DATA), qq{==}, $TEST_FILE_WORD_COUNT, qq{Add from filehandle});

throws_ok { $seqs->words_from_file(), } qr/Missing required arguments:\s+file/,
  qq{Dies on missing file};
  
throws_ok { $seqs->words_from_file(qq{Bogus_Filename}), } qr/Could not open file/,
  qq{Dies on missing file};

## Build path to the test file
my $filename = File::Spec->catfile(dirname(__FILE__), qq{word-sequences-from-files.dat});

## Test object creation
$seqs = new_ok(q{WordSequences} => [seq_length => $TEST_SEQ_LENGTH]);
cmp_ok($seqs->words_from_file($filename), qq{==}, $TEST_FILE_WORD_COUNT, qq{Add from filename});



done_testing();
__END__
arrows
carrots
give
me