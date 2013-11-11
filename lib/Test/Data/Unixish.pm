package Test::Data::Unixish;

use 5.010;
use strict;
use warnings;

use Test::More 0.96;
use Module::Load;

our $VERSION = '1.42'; # VERSION

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
                if ($t->{skip}) {
                    my $msg = $t->{skip}->();
                    plan skip_all => $msg if $msg;
                }
                my $in  = $t->{in};
                my $out = [];
                my $res = $f->(in=>$in, out=>$out, %{$t->{args}});
                is($res->[0], 200, "status");
                is_deeply($out, $t->{out}, "out")
                    or diag explain $out;
            };
        }
        $i++;
    };
}

1;
# ABSTRACT: Routines to test Data::Unixish

__END__

=pod

=encoding utf-8

=head1 NAME

Test::Data::Unixish - Routines to test Data::Unixish

=head1 VERSION

version 1.42

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=for Pod::Coverage .+

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Data-Unixish>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-Data-Unixish>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
L<https://rt.cpan.org/Public/Dist/Display.html?Name=Data-Unixish>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
