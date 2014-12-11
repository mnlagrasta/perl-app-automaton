package App::Automatan::Plugin::Source::File;

# ABSTRACT: File input module

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

__END__

=head1 SYNOPSIS

This module is intended to be used from within the App::Automatan application.

It retrieves lines from a file and adds them to the queue to be processed.

=head1 SEE ALSO

L<App::Automatan>