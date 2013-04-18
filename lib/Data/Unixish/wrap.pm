package Data::Unixish::wrap;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);
use Text::ANSI::Util qw(ta_wrap ta_mbwrap);
use Text::WideChar::Util qw(mbwrap);

our $VERSION = '1.32'; # VERSION

our %SPEC;

$SPEC{wrap} = {
    v => 1.1,
    summary => 'Wrap text',
    args => {
        %common_args,
        columns => {
            summary => 'Target column width',
            schema =>[int => {default=>80, min=>1}],
            cmdline_aliases => { c=>{} },
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
    tags => [qw/text/],
};
sub wrap {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $cols = $args{columns} // 80;
    my $ansi  = $args{ansi};
    my $mb    = $args{mb};

    while (my ($index, $item) = each @$in) {
        {
            last if !defined($item) || ref($item);
            if ($ansi) {
                if ($mb) {
                    $item = ta_mbwrap($item, $cols);
                } else {
                    $item = ta_wrap  ($item, $cols);
                }
            } elsif ($mb) {
                $item = mbwrap($item, $cols);
            } else {
                $item = Text::WideChar::Util::wrap($item, $cols);
            }
        }
        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Wrap text



__END__
=pod

=encoding utf-8

=head1 NAME

Data::Unixish::wrap - Wrap text

=head1 VERSION

version 1.32

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::List qw(dux);
 $wrapped = dux([wrap => {columns=>20}], "xxxx xxxx xxxx xxxx xxxx"); # "xxxx xxxx xxxx xxxx\nxxxx"

In command line:

 % echo -e "xxxx xxxx xxxx xxxx xxxx" | dux wrap -c 20
 xxxx xxxx xxxx xxxx
 xxxx

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 wrap(%args) -> [status, msg, result, meta]

Wrap text.

Arguments ('*' denotes required arguments):

=over 4

=item * B<ansi> => I<bool> (default: 0)

Whether to handle ANSI escape codes.

=item * B<columns> => I<int> (default: 80)

Target column width.

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<mb> => I<bool> (default: 0)

Whether to handle wide characters.

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut

