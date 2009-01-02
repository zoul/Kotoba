package Kotoba::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

sub index :Path :Args(0)
{
    my ($self, $c) = @_;
    $c->response->body($c->welcome_message);
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
    my @backgrounds = glob("root/images/bgr*.gif");
    $c->stash->{variant} = $backgrounds[int(rand(@backgrounds))];
    $c->response->content_type("text/css");
}

sub end : ActionClass('RenderView') {}

1;
