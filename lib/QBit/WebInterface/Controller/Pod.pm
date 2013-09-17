package QBit::WebInterface::Controller::Pod;

use qbit;

use base qw(QBit::WebInterface::Controller);

__PACKAGE__->model_accessors(pod => 'QBit::Application::Model::Pod');

sub show : CMD : DEFAULT {
    my ($self) = @_;

    my $data = $self->pod->show_pod($self->get_option('paths'),
        $self->request->param('path', '') . '/' . $self->request->param('file', ''))
      || return $self->from_template(\'Not found');

    if ($data->{'type'} == 1) {
        $data->{'folders'} = [];
        $data->{'files'}   = [];

        foreach my $file (@{$data->{'data'}}) {
            if ($file->{'type'} == 1) {
                push(@{$data->{'folders'}}, $file->{'name'});
            } else {
                push(@{$data->{'files'}}, $file);
            }
        }
    }

    return $self->from_template('pod/pod.tt2', vars => {data => $data});
}

TRUE;
