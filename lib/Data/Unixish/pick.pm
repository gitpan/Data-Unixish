package Data::Unixish::pick;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
use Log::Any '$log';

our $VERSION = '1.24'; # VERSION

our %SPEC;

$SPEC{pick} = {
    v => 1.1,
    summary => 'Pick one or more random items',
    args => {
        in  => {schema=>'any'},
        out => {schema=>'any'},
        items => {
            summary => 'Number of items to pick',
            schema=>['int*' => {default=>1}],
            tags => ['main'],
            cmdline_aliases => { n=>{} },
        },
    },
    tags => [qw/filtering/],
};
sub pick {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $n = $args{items} // 1;

    my @picked;
    while (my ($index, $item) = each @$in) {
        if (@picked < $n) {
            # we haven't reached n items, put item to picked list, in a random
            # position
            splice @picked, rand(@picked), 0, $item;
        } else {
            # we have reached n items, just replace an item randomly, using
            # algorithm from Learning Perl, slightly modified.
            rand($.) <= $n and $picked[rand(@picked)] = $item;
        }
    }

    push @$out, $_ for @picked;
    [200, "OK"];
}

1;
# ABSTRACT: Pick one or more random items


__END__
=pod

=head1 NAME

Data::Unixish::pick - Pick one or more random items

=head1 VERSION

version 1.24

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::pick;
 my $in  = [1..100];
 my $out = [];
 Data::Unixish::pick::pick(in=>$in, out=>$out); # $out = [73]

In command line:

 % seq 1 100 | dux pick -n 3
 .-------------------.
 | 18 | 22 |  2 | 24 |
 '----+----+----+----'

=head1 DESCRIPTION


This module has L<Rinci> metadata.

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 pick(%args) -> [status, msg, result, meta]

Pick one or more random items.

Arguments ('*' denotes required arguments):

=over 4

=item * B<in> => I<any>

=item * B<items> => I<int> (default: 1)

Number of items to pick.

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

