package Twitter::SocialGraph;

=head1 NAME

    Twitter::SocialGraph - Social Graph Methods

=head1 SYNOPSIS

    use Twitter::SocialGraph;

    my $followers = Twitter::SocialGraph::followers($args);

    my $friends = Twitter::SocialGraph::friends($args);

=head1 DESCRIPTION

    Simple functions to retrieve arrayrefs of ID's of friends or followers.

=over 4    

=cut

use Twitter::HTTP;
use Twitter::User;

=item friends($args) AND followers($args)

    Checks who is a friend of, or follows ($args->{id} or $args->{user_id} or $args->{screen_name})
    No authentication required.

    Returns an arrayref of numeric follower ID's
    
=cut    
sub followers {
    my ($args) = @_;

    my $service_url = "http://twitter.com/followers/ids.xml";     
    my $req_args = {
	url         => $service_url,
	xml_opts    => { KeyAttr => undef }
    };
    
    my $pfa_args = {
	args => $args
    };
    my $http_params = Twitter::HTTP::_params_from_args($pfa_args);

    if ( defined($http_params) ) {
	$req_args->{http_params} = $http_params;
    }
    
    my $xs = Twitter::HTTP::get($req_args);

    if ( !defined($xs) ) {
	return;
    }
    
    return $xs->{id};    
}


sub friends {
    my ($args) = @_;

    my $service_url = "http://twitter.com/friends/ids.xml";     
    my $req_args = {
	url         => $service_url,
	xml_opts    => { KeyAttr => undef }
    };
    
    my $pfa_args = {
	args => $args
    };
    my $http_params = Twitter::HTTP::_params_from_args($pfa_args);

    if ( defined($http_params) ) {
	$req_args->{http_params} = $http_params;
    }
    
    my $xs = Twitter::HTTP::get($req_args);

    if ( !defined($xs) ) {
	return;
    }
    
    return $xs->{id};    
}

=head1 BUGS

    Limitations imposed by the Twitter API will probably not allow you to query user data for all the ID's of friends / followers retrieved by these functions.
    If 1000 IDs are retrieved, for example, it will require a script throttled for at least 10 hours to retrieve user data for all using the current API limit of 100 calls/hour.    

=cut    

1;
