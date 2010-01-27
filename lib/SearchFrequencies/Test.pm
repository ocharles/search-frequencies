package SearchFrequencies::Test;
use Moose;
use MooseX::Types::Moose qw( ArrayRef );
use MooseX::AttributeHelpers;

use Statistics::Descriptive;

has 'queries' => (
    isa => ArrayRef,
    default => sub { [] },
    metaclass => 'Collection::Array',
    provides => {
        push     => 'add_query',
        elements => 'queries',
        count    => 'query_count',
        clear    => 'clear_queries',
    },
);

sub dev
{
    my $self = shift;
    my $st = Statistics::Descriptive::Full->new;
    $st->add_data(map { $_->count } $self->queries);
    return $st->standard_deviation;
}

sub mean
{
    my $self = shift;
    my $st = Statistics::Descriptive::Full->new;
    $st->add_data(map { $_->count } $self->queries);
    return $st->mean;
}

sub dev_factor
{
    my $self = shift;
    return unless $self->query_count;
    return $self->dev / $self->mean;
}

__PACKAGE__->meta->make_immutable;
1;

