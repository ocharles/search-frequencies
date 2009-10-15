package SearchFrequencies::Search::Google;
use Moose;
use REST::Google::Search;

with 'SearchFrequencies::Search';

has '+name' => ( default => 'Google' );

sub BUILD {
    REST::Google::Search->http_referer('http://www.lancs.ac.uk/~charles/');
}

sub search {
    my ($self, $query) = @_;
    my $res = REST::Google::Search->new(
        q => $query,
    );

    my $data = $res->responseData;
    my $cursor = $data->cursor;

    my $count = $cursor->estimatedResultCount;
    return $count;

}

__PACKAGE__->meta->make_immutable;
1;
