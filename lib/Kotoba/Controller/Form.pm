package Kotoba::Controller::Form;

use strict;
use warnings;
use HTML::FormFu;
use parent 'Catalyst::Controller';

our @EXPORT_OK = qw(loadForms);
our @FORM_LANGUAGES = qw(cs en ja);

=head2 loadForms

Loads all the language mutations of the contact form and returns
them as a reference to a hash indexed by the language code.

=cut

sub loadForms
{
    my $query = shift;
    my %forms;
    for my $lang (@FORM_LANGUAGES)
    {
        my $form = HTML::FormFu->new;
        $form->load_config_file("root/form/$lang.yaml");
        $form->process($query);
        $forms{$lang} = $form;
    }
    return \%forms;
}

=head2 submit

Process the submitted form. The submitted form can be any of the three
forms displayed on the title page. If the form is valid, we save it and
redirect back to the main page with a success message. If the form contains
errors, we redirect back to the main page and display the error messages.

=cut

sub submit :Local
{
    my ($self, $c) = @_;
    my $allForms = loadForms($c->request->params);
    for my $form (values %$allForms)
    {
        next unless $form->submitted;
        # ...
    }
    $c->stash->{form} = $allForms;
    $c->forward("/index");
}

=head2 save

Finish processing a valid form. The form gets sent by an e-mail.

=cut

sub save :Private
{
    my ($self, $c) = @_;
}

1;
