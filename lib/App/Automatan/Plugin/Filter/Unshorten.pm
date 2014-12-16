package App::Automatan::Plugin::Filter::Unshorten;

# ABSTRACT: Expansion of shortneded URLs

use strict;
use warnings;
use Moo;
use LWP::UserAgent;

use Data::Dumper;

sub go {
    my $self = shift;
	my $in = shift;
	my $bits = shift;
	
	my @patterns = (
		"https:\/\/t.co\/[a-z,A-Z,0-9]*", #twitter
		"http:\/\/goo.gl\/[a-z,A-Z,0-9]*", # google
		"http:\/\/bit.ly\/[a-z,A-Z,0-9]*", #http://bit.ly/1vsPSjP
		"http:\/\/bit.do\/[a-z,A-Z,0-9]*", #http://bit.do/UVBz
		"http:\/\/ow.ly\/[a-z,A-Z,0-9]*", # http://ow.ly/FiTXV
		"https:\/\/tr.im\/[a-z,A-Z,0-9]*", # https://tr.im/23498
		"http[s]?:\/\/youtu.be\/.{11}",
		"http[s]?:\/\/t.ted.com\/[a-z,A-Z,0-9]*",
	);
	
	my $pattern_string = join('|', @patterns);
	
	foreach my $bit (@$bits) {
		$bit =~ s/($pattern_string)/unshorten($1)/eg;
	}

	return 1;
}

sub unshorten {
	my $input = shift;
	my $ua = LWP::UserAgent->new;
	my $r = $ua->head($input);
	my $new_url = $r->base;
	return $new_url;
}

1;

__END__

=head1 SYNOPSIS

This module is intended to be used from within the App::Automatan application.

It expands shortened URLs to their full size so that other modules may identify them.
It currently supports the following shortening services:
 * Twitter t.co
 * Google goo.gl
 * Bitly bit.ly
 * BitDo bit.do
 * Owly ow.ly
 * Trim tr.im
 * YouTube youtu.be
 * Ted.com t.ted.com

=head1 SEE ALSO

L<App::Automatan>