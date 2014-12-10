use Test::More;
use Data::Dumper;

use_ok( 'App::Automatan::Plugin::Action::YouTube');


my $conf = {
    type => YouTube,
    target => '.'
};

my $queue = [
	'https://www.youtube.com/watch?v=jTAPsVXLu1I',
    #'https://www.youtube.com/watch?v=GD3y7ylpqO8',
    #'https://www.youtube.com/watch?v=4XWHOAeuteI'
];

my $y = App::Automatan::Plugin::Action::YouTube->new();

ok($y->go($conf, $queue), 'Go');

done_testing();