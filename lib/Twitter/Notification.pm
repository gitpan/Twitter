package Twitter::Notification;

=head1 NAME
    
    Twitter::Notification - Notification Methods (Mobile device notifications)
    
=head1 SYNOPSIS
    
    use Twitter::Notification;

    my $user = Twitter::Notification::follow($args);

    my $user = Twitter::Notification::leave($args);

=head1 BUGS

Unable to test mobile device in my location. Please notify me if this is not working for you.

=head1 DESCRIPTION

=over 4
    
=cut

use Twitter::User;
use Twitter::HTTP;

=item follow($args)

    Enables device notifications for updates from the specified user.  Returns the specified user(Twitter::User) when successful.
    See http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-notifications%C2%A0follow
    
=cut
    
sub follow {
    my ($args) = @_;
    
    my $credentials = $args->{credentials};
    my $id          = $args->{id};

    if ( !defined($credentials) ) {
	return;
    }
    
    if ( !defined($id) ) {
	return;
    }

    my $service_url = "http://twitter.com/notifications/follow/" . $id . ".xml";
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

=item leave($args)

    Disables device notifications for updates from the specified user.  Returns the specified user(Twitter::User) when successful.
    See http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-notifications%C2%A0follow
    
=cut
    
sub leave {
    my ($args) = @_;
    
    my $credentials = $args->{credentials};
    my $id          = $args->{id};

    if ( !defined($credentials) ) {
	return;
    }
    
    if ( !defined($id) ) {
	return;
    }
    
    my $service_url = "http://twitter.com/notifications/leave/" . $id . ".xml";
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

1;
