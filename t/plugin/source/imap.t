use Test::More;
use Data::Dumper;

use strict;
use warnings;

require_ok( 'App::Automatan::Plugin::Source::IMAP');

my $conf = {
	'password' => 'goodpassword',
	'server'   => 'imap.gmail.com',
	'type'     => 'IMAP',
	'ssl'      => 'yes',
	'port'     => '993',
	'account'  => 'notyourprimary@email.com'
};

ok(App::Automatan::Plugin::Source::IMAP->new(), 'new');

done_testing();