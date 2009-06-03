package Twitter::ZenTwitter;

=head1 NAME

    Twitter::ZenTwitter - A simple Twitter CLI library in Perl.
    
Uses functions from modules under Twitter to create some extended functionality.

=head1 SYNOPSIS

    use Twitter::ZenTwitter;

    my $friends_not_followers = Twitter::ZenTwitter::friends_not_followers($args);

    my $followers_not_friends = Twitter::ZenTwitter::followers_not_friends($args);

=head1 DESCRIPTION

=over 4    
    
=cut

use XML::Simple;
use Twitter::Users;
use XML::Simple;

our $VERSION = 0.11;

=item friends_not_followers($args)

    Returns an arrayref of friends(Twitter::User objects) who are not following the user identified by Credentials

=cut
    
sub friends_not_followers {
    my ($args) = @_;
    my $credentials = $args->{credentials};
    my @fnf; # we'll return a reference to this array
    
    if ( !defined($credentials) ) {
	return;
    }
    
    my $ff        = friends_and_followers($args);
    my $friends   = $ff->{friends};
    my $followers = $ff->{followers};
    
    my %followers_screen_names;

    # we'll fill the followers hash, keyed by screen_name
    # then we iterate through the friends array, reading the screen_name
    # if a user is on the friends array but the screen name is not defined on the followers hash, we push it on @fnf
    foreach my $user (@{$followers}) {
	my $screen_name = $user->screen_name();
	$followers_screen_names{$screen_name} = 1; # define it, any value goes
    }
    
    foreach my $user (@{$friends}) {
	my $screen_name = $user->screen_name();
	if ( !defined($followers_screen_names{$screen_name}) ) {
	    push @fnf, $user;
	}
    }

    return \@fnf;
}

=item followers_not_friends($args)

    Returns a list of users(Twitter::User objects) who are following, but are not followed by, the user identified by Credentials

=cut
    
sub followers_not_friends {
    my ($args) = @_;
    my $credentials = $args->{credentials};
    my @fnf; # we'll return a reference to this array
    
    if ( !defined($credentials) ) {
	return;
    }
    
    my $ff        = friends_and_followers($args);
    my $friends   = $ff->{friends};
    my $followers = $ff->{followers};

    my %friends_screen_names;

    # opposite operation from friends_not_followers
    # we'll fill the friends hash(people followed), keyed by screen_name
    # then we iterate through the followers array, reading the screen_name
    # if a user is on the followers array but the screen name is not defined on the friends hash, we push it on @fnf
    foreach my $user (@{$friends}) {
	my $screen_name = $user->screen_name();
	$friends_screen_names{$screen_name} = 1; # define it, any value goes
    }
    
    foreach my $user (@{$followers}) {
	my $screen_name = $user->screen_name();
	if ( !defined($friends_screen_names{$screen_name}) ) {
	    push @fnf, $user;
	}
    }

    return \@fnf;
}


=item friends_and_followers($args)

Obtains a full listing of both friends and followers, returned in separate keys, part of a hashref.

Parameters: $args hashref containing key 'credentials' => Twitter::Credentials object
    
Returns:
 Success: A hashref with 2 keys : 'friends' and 'followers'. Each key points to an arrayref containing a list of User objects representing the corresponding list from Twitter for the user identified in Credentials
 Failure: Void context, undef in scalar context

=cut
    
sub friends_and_followers {
    my ($args) = @_;
    my $credentials = $args->{credentials};
    my $ff; # we'll return this
    
    if ( !defined($credentials) ) {
	return;
    }

    # queries the authenticated user, identified by $credentials
    my $std_args = {
	credentials => $credentials
    };

    $ff->{friends}     = Twitter::Users::friends($std_args);
    $ff->{followers}   = Twitter::Users::followers($std_args);

    return $ff;
    
}

=back

=cut
    
1;
