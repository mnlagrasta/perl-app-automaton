use Test::More;
use Data::Dumper;

use_ok( 'App::Automatan::Plugin::Action::NZB');


my $conf = {
    type => NZB,
    target => '.'
};

my $queue = [
    'http://www.nzbsearch.net/nzb_get.aspx?mid=N8NTC',
	'https://www.nzb-rss.com/nzb/32039-James.Mays.Man.Lab.S03E01.HDTV.x264-FTP.nzb',
	'https://www.nzb-rss.com/nzb/32039-James.Mays.Man.Lab.S03E01.HDTV.x264-FTP?foo=bar&blee=blah'
];

my $y = App::Automatan::Plugin::Action::NZB->new();

ok($y->go($conf, $queue), 'Go');

done_testing();

1;