package App::Automatan::Plugin::Action::TedTalks;

# ABSTRACT: Download module for Ted Talk videos

use strict;
use warnings;
use Moo;
use WWW::Offliberty qw/off/;
use LWP::UserAgent;
use File::Spec::Functions;

use Data::Dumper;

sub go {
	my $self   = shift;
	my $in     = shift;
	my $bits   = shift;
	my $target = $in->{target} || '.';

	my $ua = LWP::UserAgent->new();

	my @patterns
		= ( "t.ted.com\/[a-z,A-Z,0-9]*", "www.ted.com\/talks\/[a-z,A-Z,0-9,_]+" );

	my $pattern_string = join( '|', @patterns );

	foreach my $bit (@$bits) {
		my @matches = $bit =~ /$pattern_string/g;
		
		foreach my $match (@matches) {
			next unless $match;
			my $name = $self->get_name($match);
			my $url = $self->get_link($match);
			#TODO: what if url is undef?'
			die "could not determine url for $match" unless $url;
			my $ua   = LWP::UserAgent->new();
			$ua->mirror( $url, catfile( $target, $name ) );
		}

	}

	return (1);
}

sub get_link {
	my $self = shift;
	my $url = shift;

	my @links = off( $url, video_file => 1 );
	print Dumper(\@links);

	my $get_link;
	foreach my $link (@links) {
		#TODO: I'd like to make this more sophisticated, with less assumption
		#TODO: Also, maybe a flag to specify language or format preference, even audio only
		if ( $link =~ m/-480p.mp4/ ) {
			$get_link = $link;
		}
	}
	
	return $get_link;
}

sub get_name {
	my $self = shift;
	my $uri = shift;

	my $name = ( split( /\//, $uri ) )[-1];

	# swap out characters that we don't want in the file name
	$name =~ s/[^a-zA-Z0-9\\-]/_/g;

	#TODO: This should be based on the "get_link" var from above?
	# put the .mp4 back on
	if ( lc( substr( $name, -4 ) ) ne '.mp4' ) {
		$name .= '.mp4';
	}

	return $name;
}

1;

__END__

=head1 SYNOPSIS

This module is intended to be used from within the App::Automatan application.

It identifies and downloads links from the Ted Talks website www.ted.com.
This is done with the help of the www.offliberty.com service, which returns
all available links. A guess is then made to get the best quality video.

=head1 SEE ALSO

L<App::Automatan>
