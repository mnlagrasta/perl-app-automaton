package App::Automatan;

# ABSTRACT: Execute various tasks based on input from various sources

use strict;
use warnings;

use Moo;
use YAML::Tiny;
use Module::Load;

use Data::Dumper;

has conf => ( is => 'rw' );
has yaml_conf => ( is => 'rw' );
has conf_file => ( is => 'rw' );
has found_bits => ( is => 'rw' );
has debug => ( is => 'rw');

sub BUILD {
    my $self = shift;
    $self->load_conf();
    return 1;
}

sub load_conf {
    my $self = shift;
    
    if ( $self->{yaml_conf} ) {
	$self->{conf} = YAML::Tiny::Load($self->{yaml_conf});
    } elsif ( $self->{conf_file} ) {
	$self->{conf} = YAML::Tiny::LoadFile($self->{conf_file}) or die;
    }
    
    $self->logger('Loaded config');
    return $self->{conf};
}

sub check_sources {
    my $self = shift;
    
    my $sources = $self->{conf}->{sources};
    foreach my $name (keys %$sources) {
	my $source = $sources->{$name};
	next if $source->{bypass};
	$self->logger("checking source: $name");
	my $mod = 'App::Automatan::Plugin::Source::' . $source->{type};
	load $mod;
	my $s = eval {$mod->new()};
	die $! unless $s;
	die $! unless $s->can('go');
	push(@{$self->{found_bits}}, $s->go($source));
    }
    
    return $1;
}

sub apply_filters {
	my $self = shift;
	
	my $filters = $self->{conf}{filters};
	foreach my $name (keys %{$filters}) {
		my $filter = $filters->{$name};
		next if $filter->{bypass};
		$self->logger("Applying filter: $name");
		my $mod = 'App::Automatan::Plugin::Filter::' . $filter->{type};
		load $mod;
		my $a = eval {$mod->new()};
		die $! unless $a;
		die $! unless $a->can('go');
		$self->found_bits($a->go($filter, $self->found_bits()));
	}
	
	return 1;
}

sub do_actions {
    my $self = shift;
    # process each action for each buffer

	my $actions = $self->{conf}{actions};
	foreach my $name (keys %$actions) {
		my $action = $actions->{$name};
		next if $action->{bypass};
		$self->logger("Executing action: $name");
		my $mod = 'App::Automatan::Plugin::Action::' . $action->{type};
		load $mod;
		my $a = eval {$mod->new()};
		die $! unless $a;
		die $! unless $a->can('go');
		my $r = $a->go($action, $self->found_bits());
		$self->logger("Unsuccessful return from action: $name");
	}
	
    return 1;
}

sub dedupe {
	my $self = shift;
	my %hash;
	$self->logger("Removing duplicates");
	@hash{@{$self->{found_bits}}} = ();
	@{$self->{found_bits}} = keys %hash;
	return 1;
}

sub logger {
	my $self = shift;
	my $message = shift;
	if ($self->{debug}) {
		print STDERR "$message\n";
	}
	return 1;
}

1;
