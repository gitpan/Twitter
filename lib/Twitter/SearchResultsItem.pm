package Twitter::SearchResultsItem;

=head1 NAME
    
    Twitter::SearchResultsItem - Zen Twitter Search Results Item
    
=head1 SYNOPSIS

    SEE Twitter::Search

=head1 DESCRIPTION

The following methods are provided:
    
=item id        => Twitter unique ID, format example: tag:search.twitter.com,2005:1820405867
    
=item published => 2009-05-16T21:57:27Z</published>
    
=item title     => Update title
    
=item content   => Update content
    
=item updated   => Date and time when this update was sent
   
=item author -> hashref
      name => Author screen_name (Name)
      uri  => http://twitter.com/screen_name

Note that $results_item->author() does not return a Twitter::User.
    
=over 4
    
=cut

use Twitter::Authentication;
use Twitter::User;
use Twitter::HTTP;
use Twitter::SearchResults;
use base 'Class::Accessor';

=item new()

=cut
    
sub new {
    my ($this, $entry) = @_;
    $this->mk_accessors(keys %{$entry});
    return bless $entry, $this;
}

=back

=cut    

1;
