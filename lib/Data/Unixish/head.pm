package Data::Unixish::head;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);

our $VERSION = '1.40'; # VERSION

our %SPEC;

$SPEC{head} = {
    v => 1.1,
    summary => 'Output the first items of data',
    args => {
        %common_args,
        items => {
            summary => 'Number of items to output',
            schema=>['int*' => {default=>10}],
            tags => ['main'],
            cmdline_aliases => { n=>{} },
        },
    },
    tags => [qw/filtering/],
};
sub head {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $n = $args{items} // 10;

    while (my ($index, $item) = each @$in) {
        last if $index >= $n;
        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Output the first items of data

__END__

=pod

=encoding utf-8

=head1 NAME

Data::Unixish::head - Output the first items of data

=head1 VERSION

version 1.40

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::head;
 my @res;
 @res = dux("head", 1..100); # => (1..10)
 @res = dux([head => {items=>3}], 1..100); # => (1, 2, 3)

In command line:

 % seq 1 100 | dux head -n 20 | dux tail --format=text-simple -n 5
 16
 17
 18
 19
 20

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 head(%args) -> [status, msg, result, meta]

Arguments ('*' denotes required arguments):

=over 4

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<items> => I<int> (default: 10)

Number of items to output.

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut
