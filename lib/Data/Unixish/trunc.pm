package Data::Unixish::trunc;

use 5.010;
use locale;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);
use Text::ANSI::Util qw(ta_trunc ta_mbtrunc);
use Text::WideChar::Util qw(mbtrunc);

our $VERSION = '1.37'; # VERSION

our %SPEC;

$SPEC{trunc} = {
    v => 1.1,
    summary => 'Truncate string to a certain column width',
    description => <<'_',

This function can handle text containing wide characters and ANSI escape codes.

Note: to truncate by character instead of column width (note that wide
characters like Chinese can have width of more than 1 column in terminal), you
can turn of `mb` option even when your text contains wide characters.

_
    args => {
        %common_args,
        width => {
            schema => ['int*', min => 0],
            req => 1,
            cmdline_aliases => { w => {} },
        },
        ansi => {
            summary => 'Whether to handle ANSI escape codes',
            schema => ['bool', default => 0],
        },
        mb => {
            summary => 'Whether to handle wide characters',
            schema => ['bool', default => 0],
        },
    },
    tags => [qw/format/],
};
sub trunc {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $w    = $args{width};
    my $ansi = $args{ansi};
    my $mb   = $args{mb};

    while (my ($index, $item) = each @$in) {
        {
            last if !defined($item) || ref($item);
            if ($ansi) {
                if ($mb) {
                    $item = ta_mbtrunc($item, $w);
                } else {
                    $item = ta_trunc($item, $w);
                }
            } elsif ($mb) {
                $item = mbtrunc($item, $w);
            } else {
                $item = substr($item, 0, $w);
            }
        }
        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Truncate string to a certain column width



__END__
=pod

=encoding utf-8

=head1 NAME

Data::Unixish::trunc - Truncate string to a certain column width

=head1 VERSION

version 1.37

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::List qw(dux);
 my @res = dux([trunc => {width=>4}], "123", "1234", "12345"); # => ("123", "1234", "1234")

In command line:

 % echo -e "123\n1234\n12345" | dux trunc -w 4 --format=text-simple
 123
 1234
 1234

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 trunc(%args) -> [status, msg, result, meta]

Truncate string to a certain column width.

This function can handle text containing wide characters and ANSI escape codes.

Note: to truncate by character instead of column width (note that wide
characters like Chinese can have width of more than 1 column in terminal), you
can turn of C<mb> option even when your text contains wide characters.

Arguments ('*' denotes required arguments):

=over 4

=item * B<ansi> => I<bool> (default: 0)

Whether to handle ANSI escape codes.

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<mb> => I<bool> (default: 0)

Whether to handle wide characters.

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=item * B<width>* => I<int>

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut

