package Mojolicious::Plugin::RemoteAddr;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

sub register {
    my ($self, $app, $conf) = @_;

    $conf->{order} ||= ['x-real-ip', 'tx'];
    
    $app->helper( remote_addr => sub {
        my $c = shift;

        foreach my $place ( @{ $conf->{order} } ) {
            if ( $place eq 'x-real-ip' ) {
                my $ip = $c->req->headers->header('X-Real-IP');
                return $ip if $ip;
            } elsif ( $place eq 'tx' ) {
                my $ip = $c->tx->remote_address;
                return $ip if $ip;
            }
        }

        return;
    }); 
}

1;
__END__

=head1 NAME

Mojolicious::Plugin::RemoteAddr - an easy way of getting remote ip address

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('RemoteAddr');
  
  # In controller
  my $ip = $self->remote_addr;
    
=head1 DESCRIPTION

L<Mojolicious::Plugin::RemoteAddr> adds simple helper "remote_addr" which returns an ip address of a remote host, It tries getting remote ip in different ways.
Firstly, it takes 'X-Real-IP' header. If it is empty it takes the ip from current request transaction.

=head1 CONFIG

=head2 order

Lookup order. Default is ['x-real-ip', 'tx']

Supported places:

=over 4

=item 'x-real-ip'  

'X-Real-IP' request header

=item 'tx' 

current request transaction

=back

=head1 HELPERS

=head2 remote_addr

Returns remote IP address

=head1 AUTHOR

Viktor Turskyi <koorchik@cpan.org>

=head1 BUGS

Please report any bugs or feature requests to Github L<https://github.com/koorchik/Mojolicious-Plugin-RemoteAddr>

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut