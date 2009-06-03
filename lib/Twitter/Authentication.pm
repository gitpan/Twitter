package Twitter::Authentication;

=head1 NAME

    Twitter::Authentication - Basic functions for Twitter authentication.

=head1 SYNOPSIS
    
    use Twitter::Authentication;

    my $credentials = Twitter::Authentication::credentials();
    my $login_data  = Twitter::Authentication::login_struct();
    my $parsed_xml  = Twitter::Authentication::read_config();

=head1 DESCRIPTION

=over 4
    
=cut

use Twitter::Credentials;
use XML::Simple;
use Cwd;

=item credentials()

    Returns a Credentials object properly filled with 'username' and 'password'
    
    Parameters: none
    Returns:
     Success: A Credentials instance
     Failure: Returns null context / undef for all scalar purposes
    
=cut
    
sub credentials {
    my ($args) = @_;

    my $ls_args = {
	filename => $args->{filename}
    };
    
    my $struct = login_struct($ls_args);

    return new Twitter::Credentials($struct);
}


=item login_struct()

    Returns a hashref with 'username' and 'password' filled in by read_config()
    
    Parameters: none
    Returns:
     Success: A hashref with username/password keys filled in
     Failure: Returns null context / undef for all purposes
    
=cut
    
sub login_struct {
    my ($args) = @_;
    my ($username, $password);

    my $rc_args = {
	filename => $args->{filename}
    };
    my $xml = read_config($rc_args);

    if ( !defined($xml) ) {
	return;
    }
    
    my $struct = {
	username => $xml->{username},
	password => $xml->{password}
    };
    
    return $struct;
}


=item read_config([$filename])

    Reads ./credentials.xml and returns a DOM-like XML hashref containing keys 'username' and 'password'
    
    Parameters: $args hashref may contain an optional path to credentials.xml in the 'filename' key                
                [Defaults to /etc/twitter/credentials.xml]
    Returns:
     Success: A XML tree hashref with the root element removed
     Failure: Returns null context / undef for all purposes
    
=cut
    
sub read_config {
    my ($args) = @_;
    my $xml;
    
    my $filename = $args->{filename};
    my $orig_filename = $filename;
    my $cwd;
    
    if ( !(-e $filename) ) {	
	$cwd = getcwd();
	$filename = "$cwd/credentials.xml";	
    }

    if ( !(-e $filename) ) {
	$filename = "/etc/twitter/credentials.xml";	
    }    
    
    if ( !(-e $filename) ) {
	# credentials.xml file not found
	die "Fatal: Unable to find the credentials.xml file under $orig_filename, $cwd/credentials.xml or /etc/twitter/credentials.xml (In that order)";
	return;
    }
    
    eval {
	$xml = XMLin($filename);
    };

    if ($@) {
	die "Fatal XML error parsing $filename: $@\n";
	return;
    }
    
    return $xml;
}

=back
    
=cut
    
1;
