package App::Automatan::Plugin::Source::File;

use strict;
use warnings;
use Moo;

sub go {
    my $self = shift;
    my $in = shift;
    my $parent = shift;

    my $file = $in->{path};
    open(my $fh, "<", $in->{path}) or die $!;
    my @lines = <$fh>;
    close($fh);
	
	if ($in->{delete}) {
		unlink $file;
	}
	
    chomp(@lines);

    return(@lines);
}

1;