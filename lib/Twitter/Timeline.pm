package Twitter::Timeline;

=head1 NAME

Twitter::Timeline - Timeline Methods
    
=head1 SYNOPSIS

use Twitter::Timeline;

my $statuses = Twitter::Timeline::public_timeline();

my $statuses = Twitter::Timeline::public_timeline($args);

my $statuses = Twitter::Timeline::user_timeline($args);

my $statuses = Twitter::Timeline::mentions($args);    


=head1 DESCRIPTION

    The Timeline methods allow you to recreate Twitter's listings of Statuses such as those you see on your Twitter home page, your friends' home page and so forth.

    There is also the public_timeline() method which returns an overall timeline created by Twitter from the latest 20 global updates.

=over 4    

=cut

use Twitter::Authentication;
use Twitter::User;
use Twitter::HTTP;
use Twitter::UserStatus;

=item public_timeline()

    Returns the 20 most recent statuses from non-protected users who have set a custom user icon.

    See http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-public_timeline

    Params: none
    Returns:
     Success: arrayref of Twitter::UserStatus
     Failure: void context / undef
    
=cut
    
sub public_timeline {
    my $service_url = "http://twitter.com/statuses/public_timeline.xml";
    my @status;
    
    my $req_args = {
	url      => $service_url,
	xml_opts => { KeyAttr => undef }
    };
    my $xs = Twitter::HTTP::get($req_args);

    if ( !defined($xs->{status}) ) {
	return;
    }

    if ( ref($xs->{status}) =~ m{ARRAY} ) {
	#arrayref of instances returned
     foreach my $status_ref ( @{$xs->{status}} ) {
	my $status_struct = {
	    status => $status_ref
	};
	push @status, new Twitter::UserStatus($status_struct);
     }
    }
    elsif ( ref($xs->{status}) =~ m{HASH} ) {
	# single instance returned - probably shouldn't happen on the public timeline.....
	my $status_struct = {
	    status => $xs->{status}
	};
	push @status, new Twitter::UserStatus($status_struct);     
    }
    else {
	return;
    }
    
    return \@status;
}


=item friends_timeline($args)

    Returns the 20 most recent statuses from the authenticated user's friends.

    http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-friends_timeline

    Params: $args must have the 'credentials' key set to a Twitter::Credentials
    Returns:
     Success: arrayref of Twitter::UserStatus
     Failure: void context / undef
    
=cut
    
sub friends_timeline {
    my ($args) = @_;
    my $service_url = "http://twitter.com/statuses/friends_timeline.xml";
    my @status;

    my $credentials = $args->{credentials};
    if ( !defined($credentials) ) {
	return;
    }
    
    my $req_args = {
	url         => $service_url,
	credentials => $credentials,
	xml_opts    => { KeyAttr => undef }
    };
    my $xs = Twitter::HTTP::get($req_args);

    if ( !defined($xs->{status}) ) {
	return;
    }

    if ( ref($xs->{status}) =~ m{ARRAY} ) {    
    foreach my $status_ref ( @{$xs->{status}} ) {
	my $status_struct = {
	    status => $status_ref
	};
	push @status, new Twitter::UserStatus($status_struct);
    }
    }
    elsif ( ref($xs->{status}) =~ m{HASH} ) {
	# single instance returned
	my $status_struct = {
	    status => $xs->{status}
	};
	push @status, new Twitter::UserStatus($status_struct);     
    }
    else {
	return;
    }
    
    return \@status;    
}


=item user_timeline($args)

    Returns the 20 most recent statuses from the authenticated user.

    http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-user_timeline

    Params: $args must have the 'credentials' key set to a Twitter::Credentials if you query a protected user

    Also accepted: id, user_id, screen_name to obtain updates for the specified ID.
    See Twitter documentation link above for additional options.
    
    Returns:
     Success: arrayref of Twitter::UserStatus
     Failure: void context / undef

=cut
    
sub user_timeline {
    my ($args) = @_;
    my $service_url = "http://twitter.com/statuses/user_timeline.xml";
    my @status;

    my $credentials = $args->{credentials};
    
    my $req_args = {
	url         => $service_url,	
	xml_opts    => { KeyAttr => undef }
    };
    
    if ( defined($credentials) ) {
	$req_args->{credentials} = $credentials;
    }

    my $pfa_args = {
	args => $args
    };
    my $http_params = Twitter::HTTP::_params_from_args($pfa_args);

    if ( defined($http_params) ) {
	$req_args->{http_params} = $http_params;
    }
    
    my $xs = Twitter::HTTP::get($req_args);

    if ( !defined($xs->{status}) ) {
	return;
    }

    if ( ref($xs->{status}) =~ m{ARRAY} ) {
    foreach my $status_ref ( @{$xs->{status}} ) {
	my $status_struct = {
	    status => $status_ref
	};
	push @status, new Twitter::UserStatus($status_struct);
    }
    }
    elsif ( ref($xs->{status}) =~ m{HASH} ) {
	# single instance returned
	my $status_struct = {
	    status => $xs->{status}
	};
	push @status, new Twitter::UserStatus($status_struct);     
    }
    else {
	return;
    }
    
    return \@status;        
}

=item mentions($args)

    Returns the 20 most recent statuses mentioning the authenticated user.

    http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-mentions

    Params: $args 'credentials' key is mandatory (Twitter::Credentials object).

    Accepts standard http parameters documented on the Twitter link above(since_id, max_id, count, page).
        
    Returns:
     Success: arrayref of Twitter::UserStatus
     Failure: void context / undef

=cut
    
sub mentions {
    my ($args) = @_;
    my $service_url = "http://twitter.com/statuses/mentions.xml";
    my @status;

    my $credentials = $args->{credentials};

    if ( !defined($credentials) ) {
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

    if ( !defined($xs->{status}) ) {
	return;
    }

    if ( ref($xs->{status}) =~ m{ARRAY} ) {
     foreach my $status_ref ( @{$xs->{status}} ) {
	my $status_struct = {
	    status => $status_ref
	};
	push @status, new Twitter::UserStatus($status_struct);
     }
    }
    elsif ( ref($xs->{status}) =~ m{HASH} ) {
	# single instance returned
	my $status_struct = {
	    status => $xs->{status}
	};
	push @status, new Twitter::UserStatus($status_struct);     
    }
    else {
	return;
    }
    
    return \@status;        

}

1;
