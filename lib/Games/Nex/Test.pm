use Games::Nex;

sub empty-game(Int $size) is export {
    return Games::Nex.new(:$size);
}

# [RAKUDO] Until RT #127789 is fixed, we can't just `Stone.enums.invert`
# But we can still remove duplication by looping over stuff:
(my %color-of-symbol){.values} = Stone::{.keys}
    given Stone.enums;

sub game-from-board(Str $description) is export {
    my $size = +$description.lines[0].words;
    die "Wrong number of lines: {+$description.lines} (expected $size)"
        unless $description.lines == $size;
    my @board = [Empty xx $size] xx $size;
    for $description.lines.kv -> $i, $line {
        die "Wrong number of cells on line $i: {+$line.words} (expected $size)"
            unless $line.words == $size;
        for $line.words.kv -> $j, $symbol {
            my $color = %color-of-symbol{$symbol} // die "Unknown symbol '$symbol'";
            @board[$i][$j] = $color;
        }
    }
    my $game = Games::Nex.new(:$size);
    $game.initialize-board(@board);
    return $game;
}
