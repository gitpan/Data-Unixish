package Data::Unixish::linum;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);

our $VERSION = '1.42'; # VERSION

our %SPEC;

$SPEC{linum} = {
    v => 1.1,
    summary => 'Add line numbers',
    args => {
        %common_args,
        format => {
            summary => 'Sprintf-style format to use',
            description => <<'_',

Example: `%04d|`.

_
            schema  => [str => default=>'%4s|'],
        },
        start => {
            summary => 'Number to start from',
            schema  => [int => default => 1],
        },
        blank_empty_lines => {
            schema => [bool => default=>1],
            description => <<'_',

Example when set to false:

    1|use Foo::Bar;
    2|
    3|sub blah {
    4|    my %args = @_;

Example when set to true:

    1|use Foo::Bar;
     |
    3|sub blah {
    4|    my %args = @_;

_
            cmdline_aliases => {
                b => {},
                B => {
                    summary => 'Equivalent to --noblank-empty-lines',
                    code => sub { $_[0]{blank_empty_lines} = 0 },
                },
            },
        },
    },
    tags => [qw/text/],
    "x.dux.strip_newlines" => 0,
};
sub linum {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});

    my $fmt = $args{format} // '%4s|';
    my $bel = $args{blank_empty_lines} // 1;
    my $lineno = ($args{start} // 1)+0;
    my $dux_cli = $args{-dux_cli};

    while (my ($index, $item) = each @$in) {
        if (defined($item) && !ref($item)) {
            my @l;
            for (split /^/, $item) {
                my $n;
                $n = ($bel && !/\S/) ? "" : $lineno;
                push @l, sprintf($fmt, $n), $_;
                $lineno++;
            }
            $item = join "", @l;
            chomp($item) if $dux_cli;
        }

        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Add line numbers

__END__

=pod

=encoding utf-8

=head1 NAME

Data::Unixish::linum - Add line numbers

=head1 VERSION

version 1.42

=head1 SYNOPSIS

In Perl:

 use Data::Unixish qw(aduxa);
 my @res = aduxa('linum', "a", "b ", "c\nd ", undef, ["e"]);
 # => ("   1|a", "   2| b", "   3c|\n   4|d ", undef, ["e"])

In command line:

 % echo -e "a\nb\n \nd" | dux linum
    1|a
    2|b
     |
    4|d

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 linum(%args) -> [status, msg, result, meta]

Arguments ('*' denotes required arguments):

=over 4

=item * B<blank_empty_lines> => I<bool> (default: 1)

Example when set to false:

    1|use Foo::Bar;
    2|
    3|sub blah {
    4|    my %args = @_;

Example when set to true:

    1|use Foo::Bar;
     |
    3|sub blah {
    4|    my %args = @_;

=item * B<format> => I<str> (default: "%4s|")

Sprintf-style format to use.

Example: C<%04d|>.

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=item * B<start> => I<int> (default: 1)

Number to start from.

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=head1 SEE ALSO

lins, rins

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
