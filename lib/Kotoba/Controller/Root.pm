package Kotoba::Controller::Root;

use strict;
use warnings;
use HTML::FormFu;
use parent 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

sub forms
{
    my @langs = qw(cs en ja);
    my %forms;
    for my $lang (@langs)
    {
        my $form = HTML::FormFu->new;
        $form->load_config_file("root/form/$lang.yaml");
        $form->process;
        $forms{$lang} = $form;
    }
    return \%forms;
}

sub index :Path :Args(0)
{
    my ($self, $c) = @_;
    my $forms = forms();
    for my $lang (keys %$forms)
    {
        $c->stash->{"form_$lang"} = $forms->{$lang};
    }
    $c->stash->{template} = "titulka.tt";
}

sub default :Path
{
    my ($self, $c) = @_;
    $c->response->body('Page not found');
    $c->response->status(404);
}

sub background :Global
{
    my ($self, $c) = @_;
    my @backgrounds = map { $_ =~ s/root//; $_ } glob("root/images/bgr*.gif");
    $c->stash->{variant} = $backgrounds[int(rand(@backgrounds))];
    $c->response->content_type("text/css");
}

sub end : ActionClass('RenderView') {}

1;
