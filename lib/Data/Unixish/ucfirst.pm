package Data::Unixish::ucfirst;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);

our $VERSION = '1.35'; # VERSION

our %SPEC;

$SPEC{ucfirst} = {
    v => 1.1,
    summary => 'Convert first character of text to uppercase',
    description => <<'_',

_
    args => {
        %common_args,
    },
    tags => [qw/text/],
};
sub ucfirst {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});

    while (my ($index, $item) = each @$in) {
        if (defined($item) && !ref($item)) {
            $item = CORE::ucfirst($item);
        }
        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Convert first character of text to uppercase



__END__
=pod

=encoding utf-8

=head1 NAME

Data::Unixish::ucfirst - Convert first character of text to uppercase

=head1 VERSION

version 1.35

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::List qw(dux);
 my @res = dux('ucfirst', 'steven', 'de Java'); # => ('Steven', 'De Java')

In command line:

 % echo -e "steven" | dux ucfirst
 Steven

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 ucfirst(%args) -> [status, msg, result, meta]

Convert first character of text to uppercase.

Arguments ('*' denotes required arguments):

=over 4

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut

