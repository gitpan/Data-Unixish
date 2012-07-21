package Test::Data::Unixish;

use 5.010;
use strict;
use warnings;

use Test::More 0.96;
use Module::Load;

our $VERSION = '1.20'; # VERSION

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(test_dux_func);

sub test_dux_func {
    my %args = @_;
    my $fn  = $args{func};
    my $fnl = $fn; $fnl =~ s/.+:://;
    load "Data::Unixish::$fn";
    my $f = "Data::Unixish::$fn\::$fnl";

    subtest $fn => sub {
        no strict 'refs';
        my $i = 0;
        for my $t (@{$args{tests}}) {
            my $tn = $t->{name} // "test[$i]";
            subtest $tn => sub {
                my $in  = $t->{in};
                my $out = [];
                my $res = $f->(in=>$in, out=>$out, %{$t->{args}});
                is($res->[0], 200, "status");
                is_deeply($out, $t->{out}, "out");
            };
            $i++;
        }
    };
}

1;
# ABSTRACT: Routines to test Data::Unixish

__END__
=pod

=head1 NAME

Test::Data::Unixish - Routines to test Data::Unixish

=head1 VERSION

version 1.20

=head1 DESCRIPTION


This module has L<Rinci> metadata.

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

