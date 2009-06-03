package Twitter::DirectMessage;

=head1 NAME
    
Twitter::DirectMessage - Direct Message Methods
    
=head1 SYNOPSIS
    
    use Twitter::DirectMessage;

    my $messages = Twitter::DirectMessage::direct_messages($args);

    my $messages = Twitter::DirectMessage::sent($args);

    my $message  = Twitter::DirectMessage::new($args);

    my $message  = Twitter::DirectMessage::destroy($args);

All functions require $args->{credentials} set. See Twitter::Credentials

=head1 DESCRIPTION
    
=over 4
    
=cut

use Twitter::HTTP;
use Twitter::Message;

=item direct_messages($args)

    Returns a list of the 20 most recent direct messages sent to the authenticating user.
    Includes detailed information about the sending and recipient users.
    See http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-direct_messages
    
    Parameters: $args hashref with 'credentials' key
    Requires $args->{credentials}

    Returns:
     Success: arrayref of Twitter::Message objects.
     Failure: void / undef
    
=cut
    
sub direct_messages {
    my ($args) = @_;
    my $service_url = "http://twitter.com/direct_messages.xml";
    my @messages;

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
    
    if ( !defined($xs->{'direct_message'}) ) {
	return;
    }

    if ( ref($xs->{'direct_message'}) =~ m{ARRAY} ) {
     foreach my $message_ref ( @{$xs->{'direct_message'}} ) {
	my $message_struct = {
	    direct_message => $message_ref
	};
	push @messages, new Twitter::Message($message_struct);
     }
    }
    elsif ( ref($xs->{'direct_message'}) =~ m{HASH} ) {
	# single instance returned
	my $message_struct = {
	    direct_message => $xs->{'direct_message'}
	};
	push @messages, new Twitter::Message($message_struct);     
    }
    else {
	return;
    }
    
    return \@messages;            
}

=item sent($args)

    Returns a list of the 20 most recent direct messages sent by the authenticating user.
    Includes detailed information about the sending and recipient users.
    See http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-direct_messages%C2%A0sent
    
    Parameters: $args hashref with 'credentials' key
    Requires $args->{credentials}

    Returns:
     Success: arrayref of Twitter::Message objects.
     Failure: void / undef
    
=cut
    
sub sent {
    my ($args) = @_;
    my $service_url = "http://twitter.com/direct_messages/sent.xml";
    my @messages;

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
    
    if ( !defined($xs->{'direct_message'}) ) {
	return;
    }

    if ( ref($xs->{'direct_message'}) =~ m{ARRAY} ) {
     foreach my $message_ref ( @{$xs->{'direct_message'}} ) {
	my $message_struct = {
	    direct_message => $message_ref
	};
	push @messages, new Twitter::Message($message_struct);
     }
    }
    elsif ( ref($xs->{'direct_message'}) =~ m{HASH} ) {
	# single instance returned
	my $message_struct = {
	    direct_message => $xs->{'direct_message'}
	};
	push @messages, new Twitter::Message($message_struct);     
    }
    else {
	return;
    }
    
    return \@messages;                
}

=item new($args)

    Sends a new direct message to the specified user from the authenticating user. Requires both the user and text parameters. Request must be a POST. Returns the sent message in the requested format when successful.
    See http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-direct_messages%C2%A0new

    Parameters: $args hashref with 'credentials', 'user' and 'text' keys

    Returns:
     Success: instance of Twitter::Message
     Failure: void / undef
    
=cut
    
sub new {
    my ($args) = @_;
    my $service_url = "http://twitter.com/direct_messages/new.xml";
    my @messages;

    my $credentials = $args->{credentials};
    my $user        = $args->{user};
    my $text        = $args->{text};
    
    if ( !defined($credentials) ) {
	return;
    }
    
    if ( !defined($user) ) {
	return;
    }
    
    if ( !defined($text) ) {
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
    
    my $xs = Twitter::HTTP::post($req_args);
    
    if ( !defined($xs) ) {
	return;
    }

    my $message_struct = {
	direct_message => $xs
    };
    
    my $message = new Twitter::Message($message_struct);
    
    return $message;                    
}


=item destroy($args)
    
    Destroys the direct message specified in the required ID parameter.  The authenticating user must be the recipient of the specified direct message.
    See http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-direct_messages%C2%A0destroy

    Parameters: $args hashref. Key 'credentials' is mandatory as well as message ID do destroy.

    Returns:
     Success: Instance of the message(Twitter::Message) that was just deleted. Note the ID will no longer be valid.
     Failure: Void / undef    
    
=cut
    
sub destroy {
    my ($args) = @_;

    my $credentials = $args->{credentials};
    if ( !defined($credentials) ) {
	return;
    }
    
    my $id = $args->{id};
    if ( !defined($id) ) {
	return;
    }
    
    my $service_url = "http://twitter.com/direct_messages/destroy/". $id . ".xml";
    my $req_args = {
	url         => $service_url,	
	xml_opts    => { KeyAttr => undef },
	credentials => $credentials
    };
    
    my $xs = Twitter::HTTP::post($req_args);
    my $message_struct = {
	direct_message => $xs
    };
    
    my $message = new Twitter::Message($message_struct);
    
    return $message;                        
}

=back

=cut
    
1;
