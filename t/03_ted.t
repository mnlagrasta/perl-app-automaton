use Test::More;
use Data::Dumper;

use_ok( 'App::Automatan::Plugin::Action::TedTalks');


my $conf = {
    type => TedTalks,
    target => '.'
};

my $queue = [
	'https://www.youtube.com/watch?v=4XWHOAeuteI',
	'http://www.ted.com/talks/paola_antonelli_why_i_brought_pacman_to_moma',
	'http://ow.ly/FiTXV',
];

my $y = App::Automatan::Plugin::Action::TedTalks->new();

ok($y->go($conf, $queue), 'Go');

done_testing();

1;