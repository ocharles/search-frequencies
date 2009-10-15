package SearchFrequencies;
use Moose;
use Module::Pluggable require => 1, sub_name => '_providers', search_path => 'SearchFrequencies::Search';

has 'providers' => (
    isa => 'ArrayRef',
    is => 'ro',
    default => sub {
        my $self = shift;
        return [ map { $_->new } $self->_providers ];
    }
);

sub search {
    my ($self, $query) = @_;
    return {
        map { $_->name => $_->search($query) } @{ $self->providers }
    };
}

__PACKAGE__->meta->make_immutable;
1;
