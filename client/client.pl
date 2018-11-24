#!/usr/bin/perl

use IO::Socket::INET;
use String::Util qw(trim);

my $commands = "Query List,
update <stock name>
max <stock name> <field>
min <stock name> <field>
get <stock name> <month/day/year>
<field> : 'open' 'high' 'low' 'close' 'volume'
Choice: ";
 
while (1)
{
    my $socket = new IO::Socket::INET(
        Proto => 'tcp',
        PeerHost => 'localhost',
        PeerPort => '50000')
    or die "cannot connect to server";
    
    my $server_address = $socket->peerhost();
    my $server_port = $socket->peerport();
    
    print "connected!\n";
    print $commands;
    
    my $req = <STDIN>;
    
    # data to send to a server
    my $size = $socket->send($req);

    # notify server that request has been sent
    shutdown($socket, 1);

    # receive a response of up to 1024 characters from server
    my $response = "";
    $socket->recv($response, 1024);
    
    print "$server_address:$server_port | $response\n\n";
    
}
 
$socket->close();
