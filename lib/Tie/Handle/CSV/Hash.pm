package Tie::Handle::CSV::Hash;

use 5.006;
use strict;
use warnings;

use Carp 'cluck';

use overload '""' => \&_stringify, fallback => 1;

sub _new
   {
   my ($class, $parent) = @_;
   my %self;
   tie(%self, $class, $parent);
   bless \%self, $class;
   }

sub TIEHASH
   {
   my ($class, $parent) = @_;
   my $self      = bless { data => {}, parent => $parent }, $class;
   my $opts      = *$parent->{opts};
   $self->{'lc'} = lc $opts->{'key_case'} eq 'any';
   return $self;
   }

sub STORE
   {
   my ($self, $key, $value) = @_;
   $key = $self->{'lc'} ? lc $key : $key;
   $self->{'data'}{$key} = $value;
   }

sub FETCH
   {
   my ($self, $key) = @_;
   $key = $self->{'lc'} ? lc $key : $key;
   return $self->{'data'}{$key};
   }

sub EXISTS
   {
   my ($self, $key) = @_;
   $key = $self->{'lc'} ? lc $key : $key;
   exists $self->{'data'}{$key};
   }

sub DELETE
   {
   my ($self, $key) = @_;
   $key = $self->{'lc'} ? lc $key : $key;
   delete $self->{'data'}{$key};
   }

sub CLEAR
   {
   my ($self) = @_;
   %{ $self->{'data'} } = ();
   }

sub FIRSTKEY
   {
   my ($self) = @_;
   my $opts   = *{ $self->{parent} }->{opts};
   $self->{'keys'} = [ @{ $opts->{'header'} } ];
   return shift @{ $self->{'keys'} };
   }

sub NEXTKEY
   {
   my ($self) = @_;
   @{ $self->{'keys'} }
      ? return shift @{ $self->{'keys'} }
      : return;
   }

sub _stringify
   {
   my ($self) = @_;
   my $under_tie = tied %$self;
   my $opts      = *{ $under_tie->{'parent'} }->{opts};
   my @keys   = @{ $opts->{'header'} };
   if ($under_tie->{'lc'})
      {
      @keys = map lc, @keys;
      }
   my @values = @{ $under_tie->{'data'} }{ @keys };
   $opts->{'csv_parser'}->combine(@values)
      || croak $opts->{'csv_parser'}->error_input();
   return $opts->{'csv_parser'}->string();
   }

1;

__END__

=head1 NAME

Tie::Handle::CSV::Hash - Support class for L<Tie::Handle::CSV>

=cut
