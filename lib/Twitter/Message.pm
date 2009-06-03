package Twitter::Message;

=head1 NAME
    
    Twitter::Message - Object representing a Direct Message
    
=head1 SYNOPSIS
    
    use Twitter::DirectMessage;

    my $messages = Twitter::DirectMessage::direct_messages($args);

    my $message = $messages->[0];

    print $message->METHOD();


Available methods:
    
=item id                    => Message ID
    
=item sender_id             => Sender ID
    
=item text                  => Message text
    
=item recipient_id          => Recipient user ID
    
=item created_at            => Date and time of creation
    
=item sender_screen_name    => Sender screen name
    
=item recipient_screen_name => Recipient screen name
    
=item sender                => Sender object (Twitter::User)
    
=item recipient             => Recipient object (Twitter::User)    

=head1 DESCRIPTION

The Message object represents a Direct Message.
It is normally returned from functions in Twitter::DirectMessage rather than directly instantiated.
    
=over 4    
    
=cut

use base 'Class::Accessor';
use Twitter::User;

=item new($args)

    Constructs a new Direct Message based on the 'direct_message' key in $args.

    Parameters: $args hashref { direct_message => direct message xml data structure returned by Twitter }

    The user and recipient keys will point to Twitter::User objects.
    
=cut
    
sub new {
    my ($this, $args) = @_;
    
    my %message = %{$args->{direct_message}};
    my $message = \%message;
    
    if ( !defined($message) ) {
	return;
    }
    
    $this->mk_accessors(keys %{$message});
    
    my $sender_struct = {
	user => $message->{sender}
    };
    $message->{sender} = new Twitter::User($sender_struct);
    
    my $recipient_struct = {
	user => $message->{recipient}
    };
    $message->{recipient} = new Twitter::User($recipient_struct);
    
    return bless $message, $this;
}


# when value is not returned by XML, return undef
# as documented in function (returns void context or undef on failure)
sub AUTOLOAD {
    return;
}

1;
