package Data::Unixish::tail;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
use Log::Any '$log';

our $VERSION = '1.23'; # VERSION

our %SPEC;

$SPEC{tail} = {
    v => 1.1,
    summary => 'Output the last items of data',
    args => {
        in  => {schema=>'any'},
        out => {schema=>'any'},
        items => {
            summary => 'Number of items to output',
            schema=>['int*' => {default=>10}],
            tags => ['main'],
            cmdline_aliases => { n=>{} },
        },
    },
    tags => [qw/filtering/],
};
sub tail {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $n = $args{items} // 10;

    # maintain temporary buffer first
    my @buf;

    while (my ($index, $item) = each @$in) {
        push @buf, $item;
        shift @buf if @buf > $n;
    }

    # push buffer to out
    push @$out, $_ for @buf;

    [200, "OK"];
}

1;
# ABSTRACT: Output the last items of data

__END__
=pod

=head1 NAME

Data::Unixish::tail - Output the last items of data

=head1 VERSION

version 1.23

=head1 DESCRIPTION


This module has L<Rinci> metadata.

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 tail(%args) -> [status, msg, result, meta]

Output the last items of data.

Arguments ('*' denotes required arguments):

=over 4

=item * B<in> => I<any>

=item * B<items> => I<int> (default: 10)

Number of items to output.

=item * B<out> => I<any>

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

