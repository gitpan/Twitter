package Twitter::Block;

=head1 NAME

    Twitter::Block - User Blocking/Unblocking and Associated Methods

=head1 SYNOPSIS
    
    use Twitter::Block;

    my $user  = Twitter::Block::create($args);
    my $user  = Twitter::Block::destroy($args);
    my $user  = Twitter::Block::exists($args);
    my $users = Twitter::Block::blocking($args);
    my $ids   = Twitter::Block::ids($args);

All functions require $args->{credentials} set. See Twitter::Credentials

=head1 DESCRIPTION

=over 4
    
=cut

use Twitter::HTTP;
use Twitter::User;

=item create($args)
    
    Blocks the user specified in the ID parameter as the authenticating user.  Returns the blocked user(Twitter::User) when successful.
    See http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-blocks%C2%A0create
    
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
    
    my $service_url = "http://twitter.com/blocks/create/" . $id . ".xml";     
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

    Un-blocks the user specified in the ID parameter for the authenticating user.  Returns the un-blocked user(Twitter::User) when successful.
    
=cut
    
sub destroy {
    my ($args) = @_;

    my $credentials = $args->{credentials};
    my $id          = $args->{id};

    if ( !defined($credentials) ) {
	return;
    }
    
    if ( !defined($id) ) {
	return;
    }
    
    my $service_url = "http://twitter.com/blocks/destroy/" . $id . ".xml";     
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

    Checks whether the authenticating user is blocking a target user.
    Will return the blocked user's object if a block exists(Twitter::User), undef otherwise(an underlying 404 not found error triggers an undef).
    
=cut
    
sub exists {
    my ($args) = @_;

    my $credentials = $args->{credentials};
    my $id          = $args->{id};

    if ( !defined($credentials) ) {
	return;
    }
    
    if ( !defined($id) ) {
	return;
    }
    
    my $service_url = "http://twitter.com/blocks/exists/" . $id . ".xml";     
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

    my $user_struct = {
	user => $xs
    };
    my $user = new Twitter::User($user_struct);
    
    return $user;    
}

=item blocking($args)
 
    Returns an array of user objects(Twitter::User) that the authenticating user is blocking.
    
=cut
    
sub blocking {
    my ($args) = @_;
    my @users;

    my $credentials = $args->{credentials};

    if ( !defined($credentials) ) {
	return;
    }
    
    my $service_url = "http://twitter.com/blocks/blocking.xml";     
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

    if ( !defined($xs->{'user'}) ) {
	return;
    }

    if ( ref($xs->{'user'}) =~ m{ARRAY} ) {
     foreach my $user_ref ( @{$xs->{'user'}} ) {
	my $user_struct = {
	    user => $user_ref
	};
	push @users, new Twitter::User($user_struct);
     }
    }
    elsif ( ref($xs->{'user'}) =~ m{HASH} ) {
	# single instance returned
	my $user_struct = {
	    user => $xs->{'user'}
	};
	push @users, new Twitter::User($user_struct);     
    }
    else {
	return;
    }
    
    return \@users;                   
}


=item ids($args)
    
    Returns an array of numeric user ids the authenticating user is blocking.
    
=cut
    
sub ids {
    my ($args) = @_;
    my @ids;

    my $credentials = $args->{credentials};

    if ( !defined($credentials) ) {
	return;
    }
    
    my $service_url = "http://twitter.com/blocks/blocking/ids.xml";     
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

    if ( !defined($xs->{'id'}) ) {
	return;
    }

    if ( ref($xs->{'id'}) =~ m{ARRAY} ) {
     foreach my $id ( @{$xs->{'id'}} ) {
	push @ids, $id;
     }
    }
    else {
	push @ids, $xs->{id};
    }

    return \@ids;                   
}

=back

=cut
    
1;
