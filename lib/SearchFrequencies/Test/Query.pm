package SearchFrequencies::Test::Query;
use Moose;
use MooseX::Types::Moose qw( Int Str );
use SearchFrequencies::Test::Types qw( Date );

has 'date' => (
    isa => Date,
    coerce => 1,
    is => 'ro',
);

has 'query' => (
    isa => Str,
    is => 'ro',
);

has 'count' => (
    isa => Int,
    is => 'ro',
    init_arg => 'estimated_count',
);

__PACKAGE__->meta->make_immutable;
1;
