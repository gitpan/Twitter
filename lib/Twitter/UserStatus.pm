package Twitter::UserStatus;

=head1 NAME
    
    Twitter::UserStatus - Object representing the status of a User.
    
=head1 SYNOPSIS    
    
    use Twitter::Status;

    # normally not used directly, but returned from other functions
    my $userstatus = Twitter::Status::show($args);

=head1 DESCRIPTION
    
Accessor methods:
    
source                  => Shows source of update. Example: 'web'. 
favorited               => 'true|false' whether the status has been favorited
truncated               => 'true|false' whether 140 chars were truncated(on Twitter.com displays a ... ).
created_at              => Date update was created.
text                    => The status message, up to 140 chars.
user                    => Points to a Twitter::User object. (Owner of the status.)
in_reply_to_user_id     => If is a reply, points to user ID being replied to.
id                      => Unique Twitter ID for this update.
in_reply_to_status_id   => If is a reply, points to status ID being replied to.
in_reply_to_screen_name => If is a reply, points to screen name being replied to.

=over 4
    
=cut

use base 'Class::Accessor';
use Twitter::User;

=item new($args)

    Constructor to new UserStatus based on the 'status' key in $args.
    The user status("What are you doing now?") is the base of the Twitter system.

    Parameters: $args hashref { status => status xml data structure returned by Twitter }      
    
=cut    
sub new {
    my ($this, $args) = @_;
    
    my %status = %{$args->{status}};
    my $status = \%status;
    
    if ( !defined($status) ) {
	return;
    }
    
    $this->mk_accessors(keys %{$status});
    
    my $user_struct = {
	user => $status->{user}
    };
    $status->{user} = new Twitter::User($user_struct);    

    return bless $status, $this;
}


# when value is not returned by XML, return undef
# as documented in function (returns void context or undef on failure)
sub AUTOLOAD {
    return;
}

=back
    
=cut
    
1;
