package Kotoba::Controller::Root;

use strict;
use warnings;
use HTML::FormFu;
use parent 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

sub index :Path :Args(0)
{
    my ($self, $c) = @_;
    my $form = HTML::FormFu->new;
    $form->load_config_file('root/form.yaml');
    $form->process;
    $c->stash->{form} = $form;
    $c->stash->{template} = "titulka.tt";
}

sub formtest :Global
{
    my ($self, $c) = @_;
    my $form = HTML::FormFu->new;
    $form->load_config_file('root/form.yaml');
    $form->process;
    $c->stash->{form} = $form;
    $c->stash->{template} = "formtest.tt";
    $c->response->content_type("text/plain");
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
