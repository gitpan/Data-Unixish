package Data::Unixish::List;

use 5.010;
use strict;
use warnings;
#use Log::Any '$log';

use Module::Load;
use SHARYANTO::Package::Util qw(package_exists);

our $VERSION = '1.31'; # VERSION

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(dux);

sub dux {
    my $f = shift;
    my $out = [];
    my %args = (in => \@_, out => $out);
    if (ref($f) eq 'ARRAY') {
        $args{$_} = $f->[1]{$_} for keys %{$f->[1]};
        $f = $f->[0];
    }

    my $pkg = "Data::Unixish::$f";
    load $pkg unless package_exists($pkg);
    my $fn = "Data::Unixish::$f\::$f";
    die "Subroutine &$fn not defined" unless defined &$fn;

    no strict 'refs';
    my $res = $fn->(%args);
    die "Dux function $fn failed: $res->[0] - $res->[1]"
        unless $res->[0] == 200;

    if (wantarray) {
        return @$out;
    } else {
        return $out->[0];
    }
}

1;
# ABSTRACT: Apply dux function to a list (and return the result as a list)


__END__
=pod

=head1 NAME

Data::Unixish::List - Apply dux function to a list (and return the result as a list)

=head1 VERSION

version 1.31

=head1 SYNOPSIS

 use Data::Unixish::List qw(dux);

 # no dux function arguments
 my @res = dux('sort', 3, 7, 1, 2); # => (1, 2, 3, 7)

 # specify dux function arguments
 my @res = dux([lpad => {width=>3, char=>'0'}], 3, 7, 1); # => ('003', '007', '001')

 # only retrieve the first row
 my @nums = (1, 2, 3, 4, "a", 5);
 my $sum  = dux(sum => @nums); # => 15

=head1 DESCRIPTION

=head1 FUNCTIONS

=head2 dux($func, @data) => LIST (OR SCALAR)

Apply dux function C<$func> to C<@data>. Return the result list. If called in
scalar context, return the first row of result list.

C<$func> is either a string containing the name of dux function (without the
C<Data::Unixish::> prefix) or a 2-element array like C<[$fname, \%args]> where
the first element is the dux function name and the second element contains the
arguments for the function. If you do not need to pass any arguments/options to
the dux function, you can use the simpler string version.

=head1 SEE ALSO

L<Data::Unixish::Apply>

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

