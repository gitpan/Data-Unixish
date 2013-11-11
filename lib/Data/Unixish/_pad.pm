package Data::Unixish::_pad;

use 5.010;
use locale;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use SHARYANTO::String::Util qw(pad);
use Text::ANSI::Util qw(ta_pad ta_mbpad);
use Text::WideChar::Util qw(mbpad);

our $VERSION = '1.42'; # VERSION

sub _pad {
    my ($which, %args) = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $w     = $args{width};
    my $ansi  = $args{ansi};
    my $mb    = $args{mb};
    my $char  = $args{char} // " ";
    my $trunc = $args{trunc};

    while (my ($index, $item) = each @$in) {
        {
            last if !defined($item) || ref($item);
            if ($ansi) {
                if ($mb) {
                    $item = ta_mbpad($item, $w, $which, $char, $trunc);
                } else {
                    $item = ta_pad  ($item, $w, $which, $char, $trunc);
                }
            } elsif ($mb) {
                $item = mbpad($item, $w, $which, $char, $trunc);
            } else {
                $item = pad  ($item, $w, $which, $char, $trunc);
            }
        }
        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: _pad

__END__

=pod

=encoding utf-8

=head1 NAME

Data::Unixish::_pad - _pad

=head1 VERSION

version 1.42

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

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
