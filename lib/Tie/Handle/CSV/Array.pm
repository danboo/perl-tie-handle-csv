package Tie::Handle::CSV::Array;

use 5.006;
use strict;
use warnings;

use overload '""' => \&_stringify, fallback => 1;

sub _new
   {
   my ($class, $parent) = @_;
   my @self;
   tie(@self, $class, $parent);
   bless \@self, $class;
   }

sub TIEARRAY
   {
   my ($class, $parent) = @_;
   return bless { data => [], parent => $parent }, $class;
   }

sub CLEAR
   {
   my ($self) = @_;
   @{ $self->{'data'} } = ();
   }

sub EXTEND
   {
   my ($self, $count) = @_;
   }

sub STORE
   {
   my ($self, $index, $value) = @_;
   $self->{'data'}[$index] = $value;
   }

sub FETCHSIZE
   {
   my ($self) = @_;
   return scalar @{ $self->{'data'} };
   }

sub FETCH
   {
   my ($self, $index) = @_;
   return $self->{'data'}[$index];
   }

sub _stringify
   {
   my ($self) = @_;
   my $under_tie = tied @{ $self };
   my @values = @{ $under_tie->{'data'} };
   my $opts      = *{ $under_tie->{'parent'} }->{opts};
   $opts->{'csv_parser'}->combine(@values)
      || croak $opts->{'csv_parser'}->error_input();
   return $opts->{'csv_parser'}->string();
   }

1;

__END__

=head1 NAME

Tie::Handle::CSV::Array - Support class for L<Tie::Handle::CSV>

=cut
