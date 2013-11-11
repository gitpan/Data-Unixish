package Data::Unixish::bool;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use utf8;
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);

our $VERSION = '1.42'; # VERSION

our %SPEC;

sub _is_true {
    my ($val, $notion) = @_;

    if ($notion eq 'n1') {
        return undef unless defined($val);
        return 0 if ref($val) eq 'ARRAY' && !@$val;
        return 0 if ref($val) eq 'HASH'  && !keys(%$val);
        return $val ? 1:0;
    } else {
        # perl
        return undef unless defined($val);
        return $val ? 1:0;
    }
}

my %styles = (
    one_zero          => ['1', '0'],
    t_f               => ['t', 'f'],
    true_false        => ['true', 'false'],
    y_n               => ['y', 'n'],
    Y_N               => ['Y', 'N'],
    yes_no            => ['yes', 'no'],
    v_X               => ['v', 'X'],
    check             => ['✓', ' ', 'uses Unicode'],
    check_cross       => ['✓', '✕', 'uses Unicode'],
    heavy_check_cross => ['✔', '✘', 'uses Unicode'],
    dot               => ['●', ' ', 'uses Unicode'],
    dot_cross         => ['●', '✘', 'uses Unicode'],

);

$SPEC{bool} = {
    v => 1.1,
    summary => 'Format boolean',
    description => <<'_',

_
    args => {
        %common_args,
        style => {
            schema=>[str => in=>[keys %styles], default=>'one_zero'],
            description => "Available styles:\n\n".
                join("", map {" * $_" . ($styles{$_}[2] ? " ($styles{$_}[2])":"").": $styles{$_}[1] $styles{$_}[0]\n"} sort keys %styles),
            cmdline_aliases => { s=>{} },
        },
        true_char => {
            summary => 'Instead of style, you can also specify character for true value',
            schema=>['str*'],
            cmdline_aliases => { t => {} },
        },
        false_char => {
            summary => 'Instead of style, you can also specify character for true value',
            schema=>['str*'],
            cmdline_aliases => { f => {} },
        },
        notion => {
            summary => 'What notion to use to determine true/false',
            schema => [str => in=>[qw/perl n1/], default => 'perl'],
            description => <<'_',

`perl` uses Perl notion.

`n1` (for lack of better name) is just like Perl notion, but empty array and
empty hash is considered false.

TODO: add Ruby, Python, PHP, JavaScript, etc notion.

_
        },
        # XXX: flag to ignore references
    },
    tags => [qw/format/],
};
sub bool {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $notion = $args{notion} // 'perl';
    my $style  = $args{style}  // 'one_zero';
    $style = 'one_zero' if !$styles{$style};

    my $tc = $args{true_char}  // $styles{$style}[0];
    my $fc = $args{false_char} // $styles{$style}[1];

    while (my ($index, $item) = each @$in) {
        my $t = _is_true($item, $notion);
        $item = $t ? $tc : defined($t) ? $fc : undef;
        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Format bool

__END__

=pod

=encoding utf-8

=head1 NAME

Data::Unixish::bool - Format bool

=head1 VERSION

version 1.42

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::List qw(dux);
 my @res = dux([bool => {style=>"check_cross"}], [0, "one", 2, ""])
 # => ("✕","✓","✓","✕")

In command line:

 % echo -e "0\none\n2\n\n" | dux bool -s y_n --format=text-simple
 n
 y
 y
 n

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 bool(%args) -> [status, msg, result, meta]

Arguments ('*' denotes required arguments):

=over 4

=item * B<false_char> => I<str>

Instead of style, you can also specify character for true value.

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<notion> => I<str> (default: "perl")

What notion to use to determine true/false.

C<perl> uses Perl notion.

C<n1> (for lack of better name) is just like Perl notion, but empty array and
empty hash is considered false.

TODO: add Ruby, Python, PHP, JavaScript, etc notion.

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=item * B<style> => I<str> (default: "one_zero")

Available styles:

=over

=item *

Y_N: N Y


=item *

check (uses Unicode):   ✓


=item *

check_cross (uses Unicode): ✕ ✓


=item *

dot (uses Unicode):   ●


=item *

dot_cross (uses Unicode): ✘ ●


=item *

heavyI<check>cross (uses Unicode): ✘ ✔


=item *

one_zero: 0 1


=item *

t_f: f t


=item *

true_false: false true


=item *

v_X: X v


=item *

y_n: n y


=item *

yes_no: no yes


=back

=item * B<true_char> => I<str>

Instead of style, you can also specify character for true value.

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

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
