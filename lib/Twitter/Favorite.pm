package Twitter::Favorite;

=head1 NAME

    Twitter::Favorite - Favorite Updates Management Methods

=head1 SYNOPSIS
    use Twitter::Favorite;

    my $statuses = Twitter::Favorite::favorites($args);
    my $status   = Twitter::Favorite::create($args);
    my $status   = Twitter::Favorite::destroy($args);

All functions require $args->{credentials} set. See Twitter::Credentials

=head1 DESCRIPTION

=over 4
    
=cut

use Twitter::HTTP;
use Twitter::User;
use Twitter::UserStatus;

=item favorites($args)

    Returns the 20 most recent favorite statuses for the authenticating user or user specified by the ID parameter in the requested format.
    
=cut
    
sub favorites {
    my ($args) = @_;
    my $service_url = "http://twitter.com/favorites.xml";
    my @statuses;

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
    
    if ( !defined($xs->{'status'}) ) {
	return;
    }

    if ( ref($xs->{'status'}) =~ m{ARRAY} ) {
     foreach my $status_ref ( @{$xs->{'status'}} ) {
	my $status_struct = {
	    status => $status_ref
	};
	push @statuses, new Twitter::UserStatus($status_struct);
     }
    }
    elsif ( ref($xs->{'status'}) =~ m{HASH} ) {
	# single instance returned
	my $status_struct = {
	    status => $xs->{'status'}
	};
	push @statuses, new Twitter::UserStatus($status_struct);     
    }
    else {
	return;
    }
    
    return \@statuses;                
}



=item create($args)

    Favorites the status specified in the ID parameter as the authenticating user. Returns the favorite status when successful.
    
=cut
    
sub create {
    my ($args) = @_;
    my @statuses;

    my $credentials = $args->{credentials};
    my $id          = $args->{id};

    if ( !defined($credentials) ) {
	return;
    }
    
    if ( !defined($id) ) {
	return;
    }
    
    my $service_url = "http://twitter.com/favorites/create/" . $id . ".xml";     
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
    
    if ( !defined($xs) ) {
	return;
    }
    
    my $status_struct = {
	status => $xs
    };
    my $status = new Twitter::UserStatus($status_struct);
    
    return $status;
}



=item destroy($args)

    Allows the authenticating users to unfollow the user specified in the ID parameter.  Returns the unfollowed user instance(Twitter::User instance)
    
=cut
    
sub destroy {
    my ($args) = @_;
    my @statuses;

    my $credentials = $args->{credentials};
    my $id      = $args->{id};

    if ( !defined($credentials) ) {
	return;
    }
    
    if ( !defined($id) ) {
	return;
    }
    
    my $service_url = "http://twitter.com/favorites/destroy/" . $id . ".xml";     
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
    if ( !defined($xs) ) {
	return;
    }
    
    my $status_struct = {
	status => $xs
    };
   
    my $status = new Twitter::UserStatus($status_struct);

    return $status;
}

=back

=cut    

1;
