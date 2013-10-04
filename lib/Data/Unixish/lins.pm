package Data::Unixish::lins;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);

our $VERSION = '1.41'; # VERSION

our %SPEC;

$SPEC{lins} = {
    v => 1.1,
    summary => 'Add some text at the beginning of each line of text',
    description => <<'_',

This is sort of a counterpart for ltrim, which removes whitespace at the
beginning (left) of each line of text.

_
    args => {
        %common_args,
        text => {
            summary => 'The text to add',
            schema  => ['str*'],
            req     => 1,
            pos     => 0,
        },
    },
    tags => [qw/text/],
};
sub lins {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $text = $args{text};

    while (my ($index, $item) = each @$in) {
        if (defined($item) && !ref($item)) {
            $item =~ s/^/$text/mg;
        }

        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Add some text at the beginning of each line of text

__END__

=pod

=encoding utf-8

=head1 NAME

Data::Unixish::lins - Add some text at the beginning of each line of text

=head1 VERSION

version 1.41

=head1 SYNOPSIS

In Perl:

 use Data::Unixish qw(aduxa);
 my @res = aduxa([lins => {text=>"xx"}, "a", " b", "", undef, ["c"]);
 # => ("xxa", "xx b", "xx", undef, ["c"])

In command line:

 % echo -e "1\n 2" | dux lins --text xx
 xx1
 xx 2

=head1 SEE ALSO

indent, rins

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 lins(%args) -> [status, msg, result, meta]

This is sort of a counterpart for ltrim, which removes whitespace at the
beginning (left) of each line of text.

Arguments ('*' denotes required arguments):

=over 4

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=item * B<text>* => I<str>

The text to add.

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut
