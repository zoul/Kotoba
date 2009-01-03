package Kotoba::Controller::Root;

use strict;
use warnings;
use HTML::FormFu;
use Kotoba::Controller::Form qw(loadForms);
use parent 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

sub index :Path :Args(0)
{
    my ($self, $c) = @_;
    $c->stash->{form} ||= loadForms();
    $c->stash->{template} = "templates/titulka.tt";
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
    $c->stash->{template} = "templates/background.tt";
    $c->response->content_type("text/css");
}

sub end :ActionClass('RenderView') {}

1;
