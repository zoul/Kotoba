package Kotoba::Controller::Root;

use strict;
use warnings;
use HTML::FormFu;
use parent 'Catalyst::Controller';
use Kotoba::Controller::Form qw(loadForms);

__PACKAGE__->config->{namespace} = '';

sub index :Path :Args(0)
{
    my ($self, $c) = @_;
    # Pass the debugging flag to the template so that we can
    # turn off the Google Analytics code in the debugging version.
    $c->stash->{debug} = $ENV{CATALYST_DEBUG} || $c->debug;
    $c->stash->{form} ||= Kotoba::Controller::Form::loadForms();
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
