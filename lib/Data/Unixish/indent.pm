package Data::Unixish::indent;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);

our $VERSION = '1.41'; # VERSION

our %SPEC;

$SPEC{indent} = {
    v => 1.1,
    summary => 'Add spaces or tabs to the beginnning of each line of text',
    args => {
        %common_args,
        num => {
            summary => 'Number of spaces to add',
            schema  => ['int*', default=>4],
            cmdline_aliases => {
                n => {},
            },
        },
        tab => {
            summary => 'Number of spaces to add',
            schema  => ['bool' => default => 0],
            cmdline_aliases => {
                t => {},
            },
        },
    },
    tags => [qw/text/],
};
sub indent {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $indent = ($args{tab} ? "\t" : " ") x ($args{num} // 4);

    while (my ($index, $item) = each @$in) {
        if (defined($item) && !ref($item)) {
            $item =~ s/^/$indent/mg;
        }

        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Add spaces or tabs to the beginning of each line of text

__END__

=pod

=encoding utf-8

=head1 NAME

Data::Unixish::indent - Add spaces or tabs to the beginning of each line of text

=head1 VERSION

version 1.41

=head1 SYNOPSIS

In Perl:

 use Data::Unixish qw(aduxa);
 my @res = aduxa('indent', "a", " b", "", undef, ["c"]);
 # => ("    a", "     b", "    ", undef, ["c"])

In command line:

 % echo -e "1\n 2" | dux indent -n 2
   1
    2

=head1 SEE ALSO

lins, rins

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 indent(%args) -> [status, msg, result, meta]

Arguments ('*' denotes required arguments):

=over 4

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<num> => I<int> (default: 4)

Number of spaces to add.

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=item * B<tab> => I<bool> (default: 0)

Number of spaces to add.

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut
