package Twitter::User;

=head1 NAME

Twitter::User - Base class for Twitter Users(friends and followers)
    
=head1 SYNOPSIS
    
    use Twitter::Users;

    my $user  = Twitter::Users::show($args);

    print $user->name() . " has user ID: " . $user->id() . "\n";

=head1 DESCRIPTION
    
   Used wherever a User is returned by Twitter(see Search for an exception to this).

   The User object provides a uniform interface to Twitter users: Friends and Followers. A myriad of data may be contained within User objects, see Accessor methods below.
    
=over 4
    
=cut    

use base 'Class::Accessor';
    
=item new($xml_data_structure)

    User constructor medthod.

    Parameters: $args hashref containing a standard Twitter hashref on the 'user' key (key names from XML service reply)
    Example return structs can be obtained from: http://twitter.com/statuses/followers.xml or friends.xml
    See Twitter::Friends module for usage examples in followers() and friends()

    Returns:
     Success: instance of User with accessors following the Twitter interface
     Failure: a void context or undef in scalar context.

Accessor methods:
    
  id                           -> numeric Twitter ID
  name                         -> users's real name
  screen_name                  -> Twitter nickname, what goes twitter.com/HERE
  location                     -> Geolocation of the user
  description                  -> self-description
  profile_image_url            -> user photo url
  url                          -> the user's home page
  protected                    -> string boolean literally 'true' or 'false', whether user's updates are protected
  followers_count              -> number of people following this user
  profile_background_color     -> 6 character html hex code without the traditional hash# (E.g. ffcc00 for bright orange)
  profile_text_color           -> 6 char html hex code for his text color
  profile_link_color           -> 6 char html hex code for profile link
  profile_sidebar_fill_color   -> 6 char html hex code for sidebar fill
  profile_sidebar_border_color -> 6 char html hex code for profile border color
  friends_count                -> number of friends (people this user is following)
  created_at                   -> signup date in format DAYOFWEEK MON DAYOFMONTH HH:MM:SS +-OFFSET YEAR
  favourites_count             -> number of favourites
  utc_offset                   -> UTC offset
  time_zone                    -> Time zone
  profile_background_image_url -> Profile background image URL
  profile_background_tile      -> string boolean 'true' or 'false' whether the bg image is tiled
  statuses_count               -> number of updates
  notifications                -> string boolean 'true' or 'false' whether user receives notifications
  following                    -> number of people following this user

  status                       -> status hashref containing the following keys (In future will be Twitter::Status object)
    created_at              -> date of this update
    id                      -> ID key of this update
    text                    -> 140 char max update(the twitter message)
    source                  -> source agent of update, shows up under the message
    truncated               -> string boolean whether was message truncated due to length
    in_reply_to_status_id   -> if replying to another update, this is the referred-to update's ID
    in_reply_to_user_id     -> if replying to another user, this is that user's numeric ID
    favorited               -> has this been favorited? boolean string
    in_reply_to_screen_name -> if replying to another user, this is that user's screen name(what goes twitte.com/HERE)
    
=cut    
sub new {
    my($this, $args) = @_;
    
    if ( !defined($args) ) {
	return;
    }
    
    my $hashref = $args->{user};
    if ( !defined($hashref) ) {
	return;
    }

    my @keys = keys %{$hashref};
    $this->mk_accessors(@keys);

    return bless $hashref, $this;
}

# when value is not returned by XML, return undef
# as documented in function (returns void context or undef on failure)
sub AUTOLOAD {
    return;
}

1;
