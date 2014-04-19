package Test::Data::Unixish;

use 5.010;
use strict;
use warnings;
use experimental 'smartmatch';

use Data::Unixish qw(aiduxa);
use Test::More 0.96;
use Module::Load;

our $VERSION = '1.43'; # VERSION

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(test_dux_func);

sub test_dux_func {
    no strict 'refs';

    my %args = @_;
    my $fn  = $args{func};
    my $fnl = $fn; $fnl =~ s/.+:://;
    load "Data::Unixish::$fn";
    my $f = "Data::Unixish::$fn\::$fnl";
    my $spec = \%{"Data::Unixish::$fn\::SPEC"};
    my $meta = $spec->{$fn};

    $meta or die "BUG: func $fn not found or does not have meta";

    my $i = 0;
    subtest $fn => sub {
        for my $t (@{$args{tests}}) {
            $i++;
            my $tn = $t->{name} // "test[$i]";
            subtest $tn => sub {
                if ($t->{skip}) {
                    my $msg = $t->{skip}->();
                    plan skip_all => $msg if $msg;
                }
                my $in   = $t->{in};
                my $out  = $t->{out};
                my $rout = [];
                my $res  = $f->(in=>$in, out=>$rout, %{$t->{args}});
                is($res->[0], 200, "status");
                is_deeply($rout, $out, "out")
                    or diag explain $rout;

                # if itemfunc, test against each item
                if ('itemfunc' ~~ @{$meta->{tags}} && ref($in) eq 'ARRAY') {
                    if ($t->{skip_itemfunc}) {
                        diag "itemfunc test skipped";
                    } else {
                        my $rout = aiduxa([$fn, $t->{args}], $in);
                        is_deeply($rout, $out, "itemfunc")
                            or diag explain $rout;
                    }
                }
            };
        }
    };
}

1;
# ABSTRACT: Routines to test Data::Unixish

__END__

=pod

=encoding UTF-8

=head1 NAME

Test::Data::Unixish - Routines to test Data::Unixish

=head1 VERSION

version 1.43

=for Pod::Coverage .+

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Data-Unixish>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-Data-Unixish>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=Data-Unixish>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
