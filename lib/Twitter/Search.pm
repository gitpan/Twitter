package Twitter::Search;

=head1 NAME
    
    Twitter::Search - Search Methods

=head1 SYNOPSIS
    
    use Twitter::Search;

    my $results = Twitter::Search::search($args);

    while ( my $result = $results->next() ) {
     print $result->title(); # see Twitter::SearchResultsItem
    }

=head1 DESCRIPTION

=over 4
    
=cut

use Twitter::Authentication;
use Twitter::User;
use Twitter::HTTP;
use Twitter::SearchResults;

=item search($args)

    Implements Twitter Search, returning Tweets that match a certain query.

    See http://apiwiki.twitter.com/Twitter-Search-API-Method%3A-search for full description of parameters.

    2009-05-17 - Plain XML is not supported here(results provided by Amazon A9??) using atom format XML...

    Parameter keys for the $args hashref:
    q => url encoded query
    lang => language of tweets to search
    rpp => results per page, use with page to control output
    page => results page, starting at 1
    since_id => returns only tweets newer than since_id's latest tweet. No pagination available for since_id queries.
    geocode => filter by location / nearby radius - See documentation on apikiwi.twitter.com for specifics
    show_user => appends user: to tweets

    Returns:
     Success: Twitter::SearchResults
     Failure: void context or undef in scalar context
    
=cut
    
sub search {
    my ($args) = @_;
    my $service_url = "http://search.twitter.com/search.atom";
    my $q = $args->{q};    

    if ( !defined($q) ) {
	return;
    }

    my $pfa_args = {
	args     => $args
    };
    my $http_params = Twitter::HTTP::_params_from_args($pfa_args);

    my $get_args = {
	url         => $service_url,
	http_params => $http_params,
	xml_opts    => { KeyAttr => undef } # keeps $res->{entry} an arrayref, in order
    };
    
    my $res = Twitter::HTTP::get($get_args);
    my $zres = new Twitter::SearchResults($res);
    
    return $zres;    
}


sub trends {

}

sub trends_current {

}

sub trends_daily {

}

sub trends_weekly {

}

=back

=head1 BUGS

The following have not yet been implemented:
    
    search
    
    trends
    
    trends_current
    
    trends_daily
    
    trends_weekly

=cut
    
1;
