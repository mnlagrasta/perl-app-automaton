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
	my $d = $in->{debug};
	
	my @patterns = (
		"http[s]?:\/\/t.co\/.{10}", #twitter
		"http[s]?:\/\/goo.gl\/[a-z,A-Z,0-9]*", # google
		"http[s]?:\/\/bit.ly\/[a-z,A-Z,0-9]*", #http://bit.ly/1vsPSjP
		"http[s]?:\/\/bit.do\/[a-z,A-Z,0-9]*", #http://bit.do/UVBz
		"http[s]?:\/\/ow.ly\/[a-z,A-Z,0-9]*", # http://ow.ly/FiTXV
		"http[s]?:\/\/tr.im\/[a-z,A-Z,0-9]*", # https://tr.im/23498
		"http[s]?:\/\/youtu.be\/.{11}",
		"http[s]?:\/\/t.ted.com\/.{7}",
	);
	
	my $pattern_string = join('|', @patterns);
	
	foreach my $bit (@$bits) {
		$bit =~ s/($pattern_string)/unshorten($d, $1)/eg;
	}

	return 1;
}

sub unshorten {
	my $d = shift;
	my $input = shift;
	my $ua = LWP::UserAgent->new;
	my $r = $ua->head($input);
	my $new_url = $r->base;
	logger($d, "Expanding $input to $new_url");
	return $new_url;
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