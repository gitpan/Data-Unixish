package Data::Unixish::lpad;

use 5.010;
use locale;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::_pad;
use Data::Unixish::Util qw(%common_args);

our $VERSION = '1.33'; # VERSION

our %SPEC;

$SPEC{lpad} = {
    v => 1.1,
    summary => 'Pad text to the left until a certain column width',
    description => <<'_',

This function can handle text containing wide characters and ANSI escape codes.

Note: to pad to a certain character length instead of column width (note that
wide characters like Chinese can have width of more than 1 column in terminal),
you can turn of `mb` option even when your text contains wide characters.

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
        char => {
            summary => 'Character to use for padding',
            schema => ['str*', len=>1, default=>' '],
            description => <<'_',

Character should have column width of 1. The default is space (ASCII 32).

_
            cmdline_aliases => { c => {} },
        },
        trunc => {
            summary => 'Whether to truncate text wider than specified width',
            schema => ['bool', default => 0],
        },
    },
    tags => [qw/format/],
};
sub lpad {
    my %args = @_;
    Data::Unixish::_pad::_pad("l", %args);
}

1;
# ABSTRACT: Pad text to the left until a certain column width


__END__
=pod

=head1 NAME

Data::Unixish::lpad - Pad text to the left until a certain column width

=head1 VERSION

version 1.33

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::List qw(dux);
 my @res = dux([lpad => {width=>6}], "123", "1234");
 # => ("   123", "  1234")

In command line:

 % echo -e "123\n1234" | dux lpad -w 6 -c x --format=text-simple
 xxx123
 xx1234

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 FUNCTIONS


=head2 lpad() -> [status, msg, result, meta]

No arguments.

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut

