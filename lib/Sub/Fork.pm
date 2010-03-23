package Sub::Fork;

use 5.008008;
use strict;
use warnings;

use base qw( Exporter ); 

our @EXPORT_OK = qw( fork );

our $VERSION = '1.01';


use Carp;
use IPC::Lite qw($buffer);



sub fork (&) {
    confess 'wrong number of paramers' unless scalar @_ == 1;
    
    my $code = shift;
    
    confess 'parameter is not coderef' unless ref $code eq 'CODE';
    
    
    $buffer = {};

    my $pid = fork();
    
    confess 'cannot fork: ' . $! unless( defined $pid );
    
    unless( $pid ) {
        my $result = undef;
        
        eval {
            $result = $code->();
        };
        
        my $error = $@;

        $buffer = {
            'result' => $result,
            'error'  => $error,
        };

        exit( 0 );
    }
    
    waitpid( $pid, 2 );
    
    die $buffer->{ 'error' } if $buffer->{ 'error' };
    return $buffer->{ 'result' };    
}

1;
__END__

=head1 NAME

Sub::Fork - Running subroutines in forked process 

=head1 SYNOPSIS

  use Sub::Fork qw( fork );
  $Sub::Fork::IPC_Shareable_size = 100000000;

  my $result = fork {
      my $a = 2 + 2 + 2 + 2;
      return $a;
  };
        
  print 'result=' . $result . "\n";

=head1 DESCRIPTION

This module provides simple interface for running subroutines in separated forked process.
Result returned via IPC::Lite interface.

=head1 FUNCTIONS

The module provides the following functions:

=head2 fork


    my $result = fork { 2 + 2 };

=head1 SEE ALSO

L<IPC::Lite> used for subroutines result return to parent process.

=head1 AUTHOR

Ivan Trunaev, <itrunaev@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 Ivan Trunaev <itrunaev@cpan.org>

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.


=cut
