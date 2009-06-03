package Twitter::Status;

=head1 NAME
    
Twitter::Status - Status Methods
    
=head1 SYNOPSIS

    use Twitter::Status;

    my $status = Twitter::Status::show($args);

    my $status = Twitter::Status::update($args);

    my $status = Twitter::Status::destroy($args);
    

=head1 DESCRIPTION

    The Status module provides the simple methods which are at the core of Twitter's functionality: show() me a status, update() my status or destroy() a certain sstatus.

    Most of the communication done on Twitter is done through UserStatus messages - which is the answer to the question "What are you doing now?".

=over 4
    
=cut

use Twitter::HTTP;
use Twitter::UserStatus;
    
=item show($args)

    Returns a single status, specified by the id parameter below.  The status's author will be returned inline.
    See: http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses%C2%A0show

    Parameters: $args hashref containing 'id' key for the status ID being queried.

    Returns:
     Success: Twitter::Status object
     Failure: void / undef
    
=cut
    
sub show {
    my ($args) = @_;

    my $credentials = $args->{credentials};

    my $id = $args->{id};
    if ( !defined($id) ) {
	return;
    }
    
    my $service_url = "http://twitter.com/statuses/show/". $id . ".xml";
    my $req_args = {
	url         => $service_url,	
	xml_opts    => { KeyAttr => undef }
    };
    
    if ( defined($credentials) ) {
	$req_args->{credentials} = $credentials;
    }

    my $xs = Twitter::HTTP::get($req_args);

    if ( !defined($xs) ) {
	return;
    }

    my $status_struct = {
	status => $xs
    };
    my $status = new Twitter::UserStatus($status_struct);
    return $status;
}


=item update($args)

    Updates the authenticated user's status with $args->{status} text.
    See: http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses%C2%A0update

    Credentials key is mandatory $args->{credentials} => Twitter::Credentials.

    Parameters: $args hashref containing new status text in 'status' key.
    
    Returns:
     Success: Newly created Twitter::Status object
     Failure: void / undef
    
=cut
    
sub update {
    my ($args) = @_;

    my $credentials = $args->{credentials};
    if ( !defined($credentials) ) {
	return;
    }
    
    my $text = $args->{status};
    if ( !defined($text) ) {
	return;
    }
    
    my $pfa_args = {
	args => $args
    };
    my $http_params = Twitter::HTTP::_params_from_args($pfa_args);
    
    my $service_url = "http://twitter.com/statuses/update.xml";
    my $req_args = {
	url          => $service_url,	
	xml_opts     => { KeyAttr => undef },
	credentials  => $credentials,
	http_params  => $http_params
    };    

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

    Deletes one of your status updates, specified by the id parameter. 
    See: http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses%C2%A0show

    Parameters: $args hashref containing 'id' key for the status ID being deleted.

    Credentials key is mandatory $args->{credentials} => Twitter::Credentials.

    Returns:
     Success: The Twitter::Status object that was just deleted. Remember its ID will no longer be valid.
     Failure: void / undef
    
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
    
    my $service_url = "http://twitter.com/statuses/destroy/". $id . ".xml";
    my $req_args = {
	url         => $service_url,	
	xml_opts    => { KeyAttr => undef },
	credentials => $credentials
    };    

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
