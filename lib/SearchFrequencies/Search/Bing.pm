package SeachFrequencies::Search::Bing;
use Moose;
use LWP::UserAgent;
use JSON::Any;

with 'SearchFrequencies::Search';

use constant END_POINT => 'http://api.bing.net/json.aspx';

has '_ua' => (
    isa => 'LWP::UserAgent',
    is => 'ro',
    default => sub {
        my $ua = LWP::UserAgent->new;
        $ua->env_proxy;
        return $ua;
    }
);

has '_app_id' => (
    isa => 'Str',
    is => 'ro',
    default => '3E4EA85144DCB426BC375A71CC3686A60A0843C0',
);

sub search {
    my ($self, $query) = @_;
    my $response = $self->_ua->get($self->_api_url(query => $query));
    if ($response->is_success) {
        my $results = JSON::Any->jsonToObj($response->content);
        use Data::Dumper;
        die Dumper ($results);
    }
}

sub _api_url {
    my ($self, %params) = @_;
    $params{AppId}   ||= $self->_app_id;
    $params{Version} ||= 2.2;
    $params{Market}  ||= 'en-GB';
    $params{Sources} ||= 'web';
    my $url = END_POINT . '?' . join '&',
        map { $_ . '=' . $params{$_} } keys %params;
    return $url;
}

__PACKAGE__->meta->make_immutable;
1;
