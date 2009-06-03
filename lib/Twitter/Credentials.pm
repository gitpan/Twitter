package Twitter::Credentials;

=head1 NAME
    
Twitter::Credentials
Standard Credentials object passed to all functions which require Twitter authentication.
    
Every function which requires authentication should accept a key named 'credentials' containing an instance of a Credentials object.  

=head1 SYNOPSIS

use Twitter::Authentication;

# Retrieves Credentials from credentials.xml file.
my $credentials_object = Twitter::Authentication::credentials();

my $args = {
    credentials => $credentials_object
};

# Retrieve an arrayref of Twitter::User objects(friends) for the user identified in $credentials_object
my $friends = Twitter::Friends::friends($args);

=cut

use base 'Class::Accessor';

# The Credentials interface will only contain methods username() and password()
# Both return strings containing the appropriate data
Twitter::Credentials->mk_accessors(qw(username password)); 

1;
