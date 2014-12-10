package App::Automatan::Plugin::Action::TedTalks;

use strict;
use warnings;
use Moo;
use WWW::Offliberty qw/off/;
use LWP::UserAgent;
use File::Spec::Functions;

use Data::Dumper;

sub go {
    my $self = shift;
	my $in = shift;
	my $bits = shift;
	my $target = $in->{target} || '.';
	
	my $ua = LWP::UserAgent->new();
	
	foreach my $bit (@$bits) {
		my ($url) = $bit =~ /(http:\/\/www.ted.com\/talks\/.+)/;
		if ($url) {
			
			my @links = off($url, video_file => 1);
		
			my $get_link;
			foreach my $link (@links) {
				#TODO: I'd like to make this more sophisticated, with less assumption
				if ($link =~ m/-480p.mp4/) {
					$get_link = $link;
				}
			}
			
			if (!$get_link) {
				print STDERR "Could not determine link to use for Ted Talk: $url\n";
				return 0;
			}

			my $name = get_name($url);
			$ua->mirror( $get_link, catfile( $target, $name ) );
			
		}
	}
	
    return(1);
}

sub get_name {
	my $uri = shift;
	
	my $name = (split(/\//, $uri))[-1];
	
	# swap out characters that we don't want in the file name
	$name =~ s/[^a-zA-Z0-9\\-]/_/g;

	#TODO: This should be based on the "get_link" var from above?
	# put the .mp4 back on
	if ( lc(substr($name, -4)) ne '.mp4' ) {
		$name .= '.mp4';
	}

	return $name;
}

1;
