package App::Automatan::Plugin::Action::NZB;

# ABSTRACT: Download module for nzb files

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
	my $d = $in->{debug};
	
	my @patterns = (
		'http:\/\/www.nzbsearch.net\/nzb_get.aspx\?mid=[a-z,A-Z,0-9]*',
		'https:\/\/www.nzb-rss.com\/nzb\/.*nzb'
	);
	my $pattern_string = join('|', @patterns);
	
	foreach my $bit (@$bits) {
		my @urls = $bit =~ /$pattern_string/g;
		foreach my $url (@urls) {
			my $name = $self->get_name($url);
			my $target_file = catfile($target, $name);
			next if -e $target_file;
			my $ua = LWP::UserAgent->new();
			logger($d, "downloading $url to $target_file");
			$ua->mirror($url, $target_file);
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

It identifies and downloads links from the following newsgroup search services:
 * www.nzb-rss.com
 * www.nzbsearch.net

=head1 SEE ALSO

L<App::Automatan>