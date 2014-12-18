package App::Automatan::Plugin::Source::File;

# ABSTRACT: File input module

use strict;
use warnings;
use Moo;

sub go {
    my $self = shift;
    my $in = shift;
    my $parent = shift;
	
	my $d = $in->{debug};

    my $file = $in->{path};
	logger($d, "Processing file: $file");
    open(my $fh, "<", $in->{path}) || return 1;
    my @lines = <$fh>;
    close($fh);
	
	if ($in->{delete}) {
		logger($d, "deleting file: $file");
		unlink $file;
	}
	
    chomp(@lines);

    return(@lines);
}

sub logger {
	my $level = shift;
	my $message = shift;
	print "$message\n" if $level;
	return 1;
}

1;

__END__

=head1 SYNOPSIS

This module is intended to be used from within the App::Automatan application.

It retrieves lines from a file and adds them to the queue to be processed.

=head1 SEE ALSO

L<App::Automatan>