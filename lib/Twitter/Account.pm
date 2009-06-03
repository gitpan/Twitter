package Twitter::Account;

=head1 NAME

    Twitter::Account - Twitter Account-related Methods   

=head1 SYNOPSIS

    use Twitter::Account;


my $user = Twitter::Account::verify_credentials($args);

my $xml  = rate_limit_status($args);

my $user = Twitter::Account::update_delivery_device($args);

my $user = Twitter::Account::update_profile_colors($args);

my $user = Twitter::Account::update_profile($args);    


=head1 DESCRIPTION

=cut

use Twitter::HTTP;
use Twitter::User;

=over 4
    
=item verify_credentials($args)

    Returns an instance of Twitter::User for the authenticated user if authentication was successful; undef otherwise.
    
=cut
    
sub verify_credentials {
    my ($args) = @_;

    my $credentials = $args->{credentials};

    if ( !defined($credentials) ) {
	return;
    }
    
    my $service_url = "http://twitter.com/account/verify_credentials.xml";     
    my $req_args = {
	url         => $service_url,
	credentials => $credentials,
	xml_opts    => { KeyAttr => undef }
    };
    
    my $xs = Twitter::HTTP::get($req_args);

    my $user_struct = {
	user => $xs
    };
    my $user = new Twitter::User($user_struct);
    
    return $user;    
}


=item rate_limit_status($args)

    If $args->{'credentials'} is provided the system returns data for the authenticated user.
    Else it will return data for your calling IP address.

    Returns:
     Success: hashref containing fields described at http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-account%C2%A0rate_limit_status
     Failure: void / undef
    
=cut
    
sub rate_limit_status {
    my ($args) = @_;

    my $credentials = $args->{credentials};

    my $service_url = "http://twitter.com/account/rate_limit_status.xml";     
    my $req_args = {
	url         => $service_url,	
	xml_opts    => { KeyAttr => undef }
    };
    
    if ( defined($credentials) ) {
	$req_args->{credentials} = $credentials;
    }
    
    my $xs = Twitter::HTTP::get($req_args);
    return $xs;    
}

=item end_session()
    
    Does not apply / Stateless client library.
    
=cut
    
sub end_session {
    return;
}


=item update_delivery_device($args)

    Sets which device Twitter delivers updates to for the authenticating user.
    Sending none as the device parameter will disable IM or SMS updates.

    Parameters: $args hashref - Required $args->{credentials} and $args->{device}
    Device can be: 'sms', 'im' or 'none'

=cut
    
sub update_delivery_device {
    my ($args) = @_;

    my $credentials = $args->{credentials};

    if ( !defined($credentials) ) {
	return;
    }

    my $device = $args->{device};
    if ( !defined($device) ) {
	return;
    }
    
    my $service_url = "http://twitter.com/account/update_delivery_device.xml";     
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


=item update_profile_colors($args)

    Sets profile page colors. Takes 5 named parameters for the colors and credentials for the account to update.

    Parameters: $args hashref - Required $args->{credentials} and the following $args keys:
    profile_background_color
    profile_text_color
    profile_link_color
    profile_sidebar_fill_color
    profile_sidebar_border_color

    See: http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-account%C2%A0update_profile_colors
    

=cut
    
sub update_profile_colors {
    my ($args) = @_;

    my $credentials = $args->{credentials};

    if ( !defined($credentials) ) {
	return;
    }

    my $service_url = "http://twitter.com/account/update_profile_colors.xml";     
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

=item update_profile_image()
=item update_profile_background_image()
    
    Multipart form data upload not yet implemented on client library.
    
=cut
    
sub update_profile_image {
    return;
}

sub update_profile_background_image {
    return;
}


=item update_profile($args)

    Sets values that users are able to set under the "Account" tab of their settings page. Only the parameters specified will be updated.

    Parameters: $args hashref - Required $args->{credentials} and the following $args keys:
    * name. Optional. Maximum of 20 characters.
    * email. Optional. Maximum of 40 characters. Must be a valid email address.
    * url. Optional. Maximum of 100 characters. Will be prepended with "http://" if not present.
    * location. Optional. Maximum of 30 characters. The contents are not normalized or geocoded in any way.
    * description. Optional. Maximum of 160 characters.

    See http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-account%C2%A0update_profile

   
=cut
    
sub update_profile {
    my ($args) = @_;

    my $credentials = $args->{credentials};

    if ( !defined($credentials) ) {
	return;
    }

    my $service_url = "http://twitter.com/account/update_profile.xml";     
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

=back

=cut
    
1;
