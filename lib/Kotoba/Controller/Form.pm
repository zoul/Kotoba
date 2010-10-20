package Kotoba::Controller::Form;

use utf8;
use strict;
use warnings;
use parent 'Catalyst::Controller';
use HTML::FormFu;
use Email::Send::SMTP::TLS;
use Email::Simple::Creator;

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

        # Turns on our custom rendering needed
        # for the validation error messages.
        $form->render_method("tt");
        $form->add_tt_args({ INCLUDE_PATH => 'root/formfu/' });

        # Inserts the language id into each form
        # so that we can find out which form has
        # been submitted.
        $form->element({ type => 'Hidden', name => 'lang', value => $lang });

        # Load the form.
        $form->load_config_file("root/form/$lang.yaml");
        # Fill the form if it has been submitted.
        $form->process($query) if ($query && $query->{lang} eq $lang);
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
    my ($form) = grep { $_->submitted } values %$allForms;

    if (not $form->has_errors)
    {
        $c->stash->{form} = $form;
        $c->forward("/form/save");
        return;
    }

    $c->stash->{form} = $allForms;
    $c->forward("/index");
}

=head2 strip_accents

This is a hack. The L<Net::SMTP::TLS> module used for sending the
e-mails has a bug in sending accented e-mailes, it truncates them
early because of wrong length calculation. Therefore we strip the
accents from the mail body before sending to get around it.

TODO: Maybe it would be enough to C<use bytes> when sending?
That way we could send e-mails with accents again.

See L<https://rt.cpan.org/Ticket/Display.html?id=62304>

=cut

sub strip_accents {
    my $str = shift;
    $str =~ tr/říšěžťčýůňúěďáéó/riseztcyunuedaeo/;
    $str =~ tr/ŘÍŠĚŽŤČÝŮŇÚĚĎÁÉÓ/RISEZTCYUNUEDAEO/;
    return $str;
}

=head2 save

Finish processing a valid form. The form contents get sent
by an e-mail to the client, the visitor gets redirected to
a “form done” page.

=cut

sub save :Private
{
    my ($self, $c) = @_;

    my $mailer = Email::Send->new({
        mailer => 'SMTP::TLS',
        mailer_args => [
            Host     => $c->config->{smtp_host},
            User     => $c->config->{smtp_sender},
            Password => $c->config->{smtp_password},
            Hello    => 'kotoba.cz',
            Port     => 587,
        ]
    });
    
    my $email = Email::Simple->create(
        header => [
            From    => $c->config->{smtp_sender},
            To      => $c->config->{smtp_recipient},
            Subject => $c->config->{smtp_subject},
        ]);
    
    $email->header_set('Content-Type' => 'text/plain; charset=UTF-8');
    $email->body_set(strip_accents($c->view('TT')->render($c, 'templates/mail.tt')));

    eval { $mailer->send($email) };

    # We use an ordinary forward here instead of redirect,
    # so that the user has a chance to resubmit the form by
    # reloading the page.
    if ($@) {
        $c->log->debug($@);
        $c->forward("/form/error");
        return;
    }

    my $lang = $c->stash->{form}->param_value("lang");
    $c->response->redirect("/form/done/$lang");
}

=head2 error

Tells the visitor there has been an error submitting the form.

=cut

sub error :Local
{
    my ($self, $c) = @_;
    my $lang = $c->stash->{form}->param_value("lang");
    $c->stash->{template} = "templates/error-$lang.tt";
}

=head2 done

Tells the visitor the form has been succesfully submitted.

=cut

sub done :Local
{
    my ($self, $c, $lang) = @_;
    $c->stash->{template} = "templates/done-$lang.tt";
}

1;
