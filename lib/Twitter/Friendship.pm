package Twitter::Friendship;

=head1 NAME

    Twitter::Friendship - Friendship Methods
    
=head1 SYNOPSIS
    use Twitter::Friendship;

    my $user = Twitter::Friendship::create($args);

    my $user = Twitter::Friendship::destroy($args);

    my $bool = Twitter::Friendship::exists($args);

All functions require $args->{credentials} set. See Twitter::Credentials

=head1 DESCRIPTION

=over 4
    
=cut

use Twitter::HTTP;
use Twitter::User;

=item create($args)

    Allows the authenticating users to follow the user specified in the ID parameter.  Returns the befriended user instance(Twitter::User instance).
    
=cut
    
sub create {
    my ($args) = @_;

    my $credentials = $args->{credentials};
    my $id          = $args->{id};

    if ( !defined($credentials) ) {
	return;
    }
    
    if ( !defined($id) ) {
	return;
    }
    
    my $service_url = "http://twitter.com/friendships/create/" . $id . ".xml";     
    my $req_args = {
	url         => $service_url,
	credentials => $credentials,
	xml_opts    => { KeyAttr => undef }
    };
    
    my $pfa_args = {
	args => $args
    };
    my $http_params = Twitter::HTTP::_params_from_args($pfa_args);

    if ( defined($http_params) ) {
	$req_args->{http_params} = $http_params;
    }
    
    my $xs = Twitter::HTTP::post($req_args);

    my $user_struct = {
	user => $xs
    };
    my $user = new Twitter::User($user_struct);
    
    return $user;
}


=item destroy($args)

    Allows the authenticating users to unfollow the user specified in the ID parameter.  Returns the unfollowed user instance(Twitter::User instance)
    
=cut
    
sub destroy {
    my ($args) = @_;

    my $credentials = $args->{credentials};
    my $id      = $args->{id};

    if ( !defined($credentials) ) {
	return;
    }
    
    if ( !defined($id) ) {
	return;
    }
    
    my $service_url = "http://twitter.com/friendships/destroy/" . $id . ".xml";     
    my $req_args = {
	url         => $service_url,
	credentials => $credentials,
	xml_opts    => { KeyAttr => undef }
    };
    
    my $pfa_args = {
	args => $args
    };
    my $http_params = Twitter::HTTP::_params_from_args($pfa_args);

    if ( defined($http_params) ) {
	$req_args->{http_params} = $http_params;
    }
    
    my $xs = Twitter::HTTP::post($req_args);
    my $user_struct = {
	user => $xs
    };
    my $user = new Twitter::User($user_struct);
    
    return $user;
}


=item exists($args)

    Return true(1) if user_a FOLLOWS user_b, otherwise will return false(0).

    Authentication required. 

    Parameters: $args->{user_a} and $args->{user_b} and $args->{credentials} are mandatory.
    
=cut
    
sub exists {
    my ($args) = @_;
    my $service_url = "http://twitter.com/friendships/exists.xml"; 

    my $credentials = $args->{credentials};
    my $user_a      = $args->{user_a};
    my $user_b      = $args->{user_b};    

    if ( !defined($credentials) ) {
	return;
    }
    
    if ( !defined($user_a) ) {
	return;
    }
    
    if ( !defined($user_b) ) {
	return;
    }    
    
    my $req_args = {
	url         => $service_url,
	credentials => $credentials,
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
    
    return lc($xs) eq 'true' ? 1 : 0;
}

=back

=cut    

1;
