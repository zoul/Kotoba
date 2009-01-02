package Kotoba::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

sub index :Path :Args(0)
{
    my ($self, $c) = @_;
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
    my @backgrounds = glob("root/images/bgr*.gif");
    my $variant = $backgrounds[int(rand(@backgrounds))];
    ($c->stash->{variant} = $variant) =~ s/root//;
    $c->response->content_type("text/css");
}

sub end : ActionClass('RenderView') {}

1;
