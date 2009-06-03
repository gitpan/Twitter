package Twitter::HTTP;

=head1 NAME

    Twitter::HTTP - Common HTTP functions for Twitter XML services.

=head1 SYNOPSIS
    
    use Twitter::HTTP;

    my $parsed_xml = Twitter::HTTP::get($args);

    my $parsed_xml = Twitter::HTTP::post($args);

=head1 DESCRIPTION

    HTTP request methods for GET and POST.
    The $args hashref accepts standard parameters in the keys:
    
=item credentials => Twitter::Credentials object for requests requiring authentication
    
=item url => $url to GET or POST
    
=item http_params => hashref of parameters to add to request
    
=item xml_opts => hashref passed to XML::Simple function XMLin(xml, %{$xml_opts})

Returns a hashref created from parsing the returned XML via XML::Simple.

=over 4    
    
=cut

use Twitter::UserAgent;
use HTTP::Request::Common qw(POST GET);
use XML::Simple;
use URI;

our $ua = new Twitter::UserAgent();

=item get($args)

    Defaults to plain XML format parsing.
    
    Parameters: $args hashref containing:
     credentials => Twitter::Credentials object (Optional)
     url => $url to GET,
     http_params => hashref of parameters to add to get query
     xml_opts => hashref passed to XML::Simple function XMLin(xml, %{$xml_opts})
    
    Returns:
     Success: hashref containing the parsed XML response
     Failure: void context / undef
    
=cut
    
sub get {
    my ($args) = @_;
    my $credentials = $args->{credentials};    
    my $url         = $args->{url};
    my $http_params = $args->{http_params};
    my $xml_opts    = $args->{xml_opts};
    my %xml_opts    = ();

    if ( defined($xml_opts) ) {
	%xml_opts = %{$xml_opts}
    }

    my $xml = plain_get($args);
    my $xs;

    eval {
	$xs = XMLin($xml, %xml_opts);
    };

    if ( $@ ) {
	return;
    }

    return $xs;
}


sub plain_get {
    my ($args) = @_;
    my %args = %{$args};
    $args{method} = 'GET';
    my $content = _do_request(\%args);    
    return $content;    
}

=item post($args)
    
    Defaults to plain XML format parsing.
    
    Parameters: $args hashref containing:
     credentials => Twitter::Credentials object (Optional)
     url => $url to GET,
     http_params => hashref of parameters for POST content
     xml_opts => hashref passed to XML::Simple function XMLin(xml, %{$xml_opts})
    
    Returns:
     Success: hashref containing the parsed XML response
     Failure: void context / undef
    
=cut
    
sub post {
    my ($args) = @_;
    my $credentials = $args->{credentials};    
    my $url         = $args->{url};
    my $http_params = $args->{http_params};
    my $xml_opts    = $args->{xml_opts};
    my %xml_opts    = ();

    if ( defined($xml_opts) ) {
	%xml_opts = %{$xml_opts}
    }
    
    my $xml = plain_post($args);
    my $xs;
    
    eval {
	$xs = XMLin($xml, %xml_opts);
    };

    if ( $@ ) {
	return;
    }

    return $xs;
}

sub plain_post {
    my ($args) = @_;
    my %args = %{$args};
    $args{method} = 'POST';
    my $content = _do_request(\%args);    
    return $content;
}


sub _do_request {
    my ($args) = @_;
    my $credentials = $args->{credentials};    
    my $url         = $args->{url};
    my $http_params = $args->{http_params};
    my $method      = $args->{method};

    if ( !defined($url) ) {
	return undef;
    }

    if ( !defined($method) ) {
	return undef;
    }
    
    my $uri = new URI($url);

    if ( defined($args->{http_params}) ) {
	$uri->query_form($args->{http_params});
    }
    
    my $req = eval "$method \$uri";
    
    if ( defined($credentials) ) {
	$req->authorization_basic( $credentials->username(), $credentials->password() );	
    }
    
    my $res = $ua->request($req);

    if ( !$res->is_success() ) {
	return;
    }
    
    return $res->content();        
}

sub _params_from_args {
    my ($args) = @_;
    my %http_params = ();
    
    # default reserved library keys, may collide, let's see
    my %bad_keys = (credentials => 1, http_params => 1, args => 1);     

    if ( !defined($args->{args}) ) {
	return;
    }

    if ( defined($args->{$bad_keys}) ) {
	foreach my $key ( @{$args->{bad_keys}} ) {
	    $bad_keys{$key}++;
	}
    }

    my $orig_args = $args->{args};
    foreach my $key ( %{$orig_args} ) {
	next if($bad_keys{$key});
	if ( defined($orig_args->{$key}) ) {
	    $http_params{$key} = $orig_args->{$key};
	}
    }

    return \%http_params;
}


=back
    
=cut    

1;
