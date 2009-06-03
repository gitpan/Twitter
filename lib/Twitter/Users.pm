package Twitter::Users;

=head1 NAME
    
    Twitter::User - User Methods

=head1 SYNOPSIS

    use Twitter::Users;

    my $user  = Twitter::Users::show();

    my $users = Twitter::Users::friends();

    my $users = Twitter::Users::followers();
    
=head1 DESCRIPTION

=over 4    

=cut

use Twitter::Authentication;
use Twitter::User;
use Twitter::HTTP;
use XML::Simple;

=item show($args)
    
    $args is hashref that must contain one of the following keys:    
    id          => User ID or screen name to query
    user_id     => Numeric user ID to query
    screen_name => Screen name to query

    Authentication is not required unless user is protected.

    Response:
     Success: Instance of a Twitter::User object
     Failure: Void context or undef
    
=cut
    
sub show {
    my ($args) = @_;
    
    my $service_url = "http://twitter.com/users/show.xml";
    my $service_params = {};
    
    if ( defined($args->{id}) ) {
	$service_params->{id} = $args->{id};
    }
    
    if ( defined($args->{user_id}) ) {
	$service_params->{user_id} = $args->{user_id};
    }
    
    if ( defined($args->{screen_name}) ) {
	$service_params->{screen_name} = $args->{screen_name};
    }
    
    my $get_args = {
	url         => $service_url,
	http_params => $service_params
    };

    my $xs = Twitter::HTTP::get($get_args);
    
    if ( !defined($xs) ) {
	# http request failed
	return;
    }

    my $user_struct = {
		user => $xs
    };

    my $user = new Twitter::User($user_struct);    
    return $user;    
    
}

=item friends()
    
    Returns:
     Success: A @list of Twitter::User objects from your friends list(people you follow on Twitter).
     Failure: Void or undef in scalar context.

    This will retrieve pages of 100 results until < 100 are retrieved, meaning an error or normal EOF happened.
    There is no error handling, this is not a mission critical application.
    
=cut
    
sub friends {
    my ($args) = @_;
    my $ua = new UserAgent();
    my $page = 1;
    my $service_url = "http://twitter.com/statuses/friends.xml";
    my @friends;

    my $credentials = $args->{credentials};

    # loop until returned results != 100
    my $name_count = 0;
    do {
	my $paged_url = $service_url . "?page=" . $page;
	
	my $get_args = {
	 url         => $paged_url,
	 credentials => $credentials
	};

	my $xs = Twitter::HTTP::get($get_args);
	if ( !defined($xs) ) {
	    # http request failed
	    return \@friends; # returns what we got up until now
	}
	
	my @names = keys %{$xs->{user}};
	$name_count = @names;
	
	foreach my $name (@names) {
	    my $user_ref = $xs->{user}->{$name};
	    $user_ref->{name} = $name; # XMLin uses the name key as the hash key, we return it to the user struct
	    my $friend_struct = {
		user => $user_ref
	    };

	    my $friend = new Twitter::User($friend_struct);
	    push @friends, $friend;
	}	
	$page++;
	
    } while ($name_count >= 99);    
    
    return \@friends;
}


=item followers()
    
    Returns:
     Success: A @list of Twitter::User objects from your followers list(people who follow you on Twitter).
     Failure: Void or undef in scalar context.
    
=cut
    
sub followers {
    my ($args) = @_;
    my $ua = new UserAgent();
    my $page = 1;
    my $service_url = "http://twitter.com/statuses/followers.xml";
    my @followers;

    my $credentials = $args->{credentials};

    # loop until returned results != 100
    my $name_count = 0;
    do {
	my $paged_url = $service_url . "?page=" . $page;
	
	my $get_args = {
	 url         => $paged_url,
	 credentials => $credentials
	};

	my $xs = Twitter::HTTP::get($get_args);
	if ( !defined($xs) ) {
	    # http request failed
	    return \@followers; # returns what we got up until now
	}
	
	my @names = keys %{$xs->{user}};
	$name_count = @names;
	
	foreach my $name (@names) {
	    my $user_ref = $xs->{user}->{$name};
	    $user_ref->{name} = $name; # XMLin uses the name key as the hash key, we return it to the user struct
	    my $follower_struct = {
		user => $user_ref
	    };

	    my $follower = new Twitter::User($follower_struct);
	    push @followers, $follower;
	}
	
	$page++;
    } while ($name_count >= 99);    

    
    return \@followers;    
}

=back
    
=head1 BUGS

    First page always returns 99 results, did not investigate further.
    
=cut
    
1;
