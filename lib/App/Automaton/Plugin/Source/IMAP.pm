package App::Automaton::Plugin::Source::IMAP;

# ABSTRACT: IMAP email input module

use strict;
use warnings;

use Moo;
use Net::IMAP::Simple;
use Email::Simple;

use Data::Dumper;

sub go {
	my $self = shift;
	my $in   = shift;
	my $d = $in->{debug};

	my $server = $in->{server} . ':' . $in->{port};

	# Create the object
	my $imap = Net::IMAP::Simple->new( $server, use_ssl => $in->{ssl} )
		|| die "Unable to connect to IMAP: $Net::IMAP::Simple::errstr\n";

	# Log on
	$imap->login( $in->{account}, $in->{password} )
		|| die "imap login failed";

	my @output;

	# Get messages
	my $nm = $imap->select('INBOX');
	_logger($d, "Found $nm messages");
	for ( my $i = 1; $i <= $nm; $i++ ) {
		_logger($d, "getting message $i");
		#my $message = $imap->get( $i, 2 ) || $imap->get($i);
		my $message = $imap->get($i);
		die("imap message undef") unless defined $message;
		
		push( @output, $message );
		
		if ($in->{delete}) {
			# delete message
			_logger($d, "Deleting message $i");
			$imap->delete($i);
		}
		
	}
	chomp(@output);    #probably not needed, maybe even a bad idea
	return (@output);
}


sub _logger {
	my $level = shift;
	my $message = shift;
	print "$message\n" if $level;
	return 1;
}

1;

__END__

=head1 SYNOPSIS

This module is intended to be used from within the App::Automaton application.

It retrieves messages from an IMAP email account and adds them to the queue to be processed.

=head1 METHODS

=over 4

=item go

Executes the plugin. Expects input: conf as hashref, queue as arrayref

=back

=head1 SEE ALSO

L<App::Automaton>
