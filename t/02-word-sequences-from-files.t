##----------------------------------------------------------------------------
## :mode=perl:indentSize=2:tabSize=2:noTabs=true:
##----------------------------------------------------------------------------
use Test::More;
use Test::Exception;
use WordSequences;
use Readonly;

my $seqs;
## Test object creation
$seqs = new_ok(q{WordSequences});

cmp_ok($seqs->seq_length, qq{==}, 4, qq{Verify default sequence length});


done_testing();
__END__

__DATA__
supple
supplant
plant
planted
plants
