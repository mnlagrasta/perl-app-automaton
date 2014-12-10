package App::Automatan::Plugin::Source::IMAP;

use strict;
use warnings;

use Moo;
use Net::IMAP::Simple;
use Email::Simple;

use Data::Dumper;

sub go {
	my $self = shift;
	my $in   = shift;

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
	for ( my $i = 1; $i <= $nm; $i++ ) {
		print "processing message $i\n";
		my $message = $imap->get( $i, 2 ) . '' or die $imap->errstr;
		push( @output, $message );
		
		if ($in->{delete}) {
			# delete message
			$imap->delete($i);
		}
		
	}
	chomp(@output);    #probably not needed, maybe even a bad idea
	return (@output);
}

1;
