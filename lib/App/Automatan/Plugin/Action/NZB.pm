package App::Automatan::Plugin::Action::NZB;

use strict;
use warnings;
use Moo;
use LWP::UserAgent;
use File::Spec::Functions;

use Data::Dumper;

sub go {
    my $self = shift;
	my $in = shift;
	my $bits = shift;
	my $target = $in->{target} || '.';
	
	my @patterns = (
		'(http:\/\/www.nzbsearch.net\/nzb_get.aspx\?mid=[a-z,A-Z,0-9]*)',
		'(https:\/\/www.nzb-rss.com\/nzb\/.*nzb)'
	);
	my $pattern_string = join('|', @patterns);
	
	foreach my $bit (@$bits) {
		my @matches = $bit =~ $pattern_string;
		foreach my $match (@matches) {
			next unless $match;
			my $name = $self->get_name($match);
			my $ua = LWP::UserAgent->new();
			$ua->mirror($match, catfile($target, $name));
		}
	}
	
    return(1);
}

sub get_name {
	my $self = shift;
	my $uri = shift;

	my $name = (split(/\//, $uri))[-1];
	
	# swap out characters that we don't want in the file name
	$name =~ s/[^a-zA-Z0-9\\-]/_/g;
	
	# ensure file name ends in .nzb for ease
	if ( lc(substr($name, -4)) ne '.nzb' ) {
		$name .= '.nzb';
	}
	
	return $name;
}

1;
