package SearchFrequencies::Test::Types;
use MooseX::Types -declare => [qw( Date ) ];
use MooseX::Types::Moose qw( Str );
use DateTime::Format::SQLite;

class_type Date, { class => 'DateTime' };

coerce Date,
    from Str,
    via sub { DateTime::Format::SQLite->parse_datetime($_) };

1;
