package Twitter::Help;

=head1 NAME
    
    Twitter::Help - Help/Diagnostic Method
    
=head1 SYNOPSIS

    use Twitter::Help;

    my $response = Twitter::Help::test();

=head1 DESCRIPTION

    This module basically tests communications with the Twitter servers.
    The test function returns a response string from the server, normally "OK" or undef if communication is unavailable.

=over 4
    
=cut
    
use Twitter::HTTP;

=item test()

    Sends a single message to Twitter.com's servers to test connectivity.
    Returns a response string, normally 'OK' on success or undef otherwise.
    
=cut    
sub test {
    my $service_url = "http://twitter.com/help/test.xml";
    
    my $req_args = {
	url      => $service_url
    };
    my $xs = Twitter::HTTP::get($req_args);
    return $xs;
}    

=back

=cut

1;
