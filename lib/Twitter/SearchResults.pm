package Twitter::SearchResults;

=head1 NAME

    Twitter::SearchResults - Simple recordset-like interface to Twitter Search Results

=head1 SYNOPSIS

    my $results = new Twitter::SearchResults($xml);

    print $results->size() . " Results Found\n";

B<NOTE:> All methods are instance methods, not to be used statically like most of the rest of the Twitter lib.
       
SEE Twitter::Search

=head1 DESCRIPTION

    Uniform interface to Twitter search results. Currently, it seems, Twitter's search is a separate system from their main REST API.

=over 4
         
=cut

use Twitter::Authentication;
use Twitter::User;
use Twitter::HTTP;
use Twitter::SearchResults;
use Twitter::SearchResultsItem;

=item new($this, $xmlresult)

    Constructor, takes Twitter's parsed search results XML as a parameter.
    
=cut    

sub new {
    my ($this, $xmlres) = @_;

    my $state = {
      xmlres => $xmlres,
      pos    => 0,
      size   => @{ $xmlres->{entry} } # item count
    };
    return bless $state, $this;
}

=item reset()

    Resets the SearchResults to position 0 so the first result is returned next()
    
=cut    

sub reset {
    my ($this) = @_;
    $this->{pos} = 0;
}

=item next()

    Returns the next available SearchResultItem.
    SearchResults will point to the next item after the call.
    
=cut    

sub next {
    my ($this) = @_;
    $this->{pos}++;
    return $this->get($this->{pos});
}

=item first()

    Returns the first available SearchResultItem.
    The first call to next() after first() will return item #2
    
=cut
    
sub first {
    my ($this) = @_;
    $this->{pos} = 0;
    return $this->get($this->{pos});
}


=item size()

    Returns the number of SearchResult items on this instance of SearchResults
    
=cut
    
sub size {
    my ($this) = @_;
    return $this->{size};
}


=item get($pos)

    Returns the SearchResultItem in position $pos.
    
=cut
    
sub get {
    my ($this, $pos) = @_;
    my $entry  = $this->{xmlres}->{entry}->[$pos];
    if ( !defined($entry) ) {
	return;
    }
    return new Twitter::SearchResultsItem($entry);
}

=back
    
=head1 BUGS
    
This module currently does not use CPAN's XML::Atom. There were reasons for this, perhaps these reasons won't make sense in the future, so I'll leave it as a bug.

=cut
    
1;
