package Twitter::UserAgent;

=head1 NAME

Twitter::UserAgent : Utility module for a pre-configured LWP::UserAgent and future related functions.

=head1 SYNOPSIS

use Twitter::UserAgent;

my $ua = Twitter::UserAgent::new();
    
=cut

use LWP::UserAgent;

sub new {
    my $user_agent = "Mozilla/4.1 (Zen Twitter Agent; Please see zefonseca.com/blogs/zen/; Havin' fun yet?)";
    my $ua = new LWP::UserAgent();
    $ua->agent($user_agent);
    return $ua
}

1;
