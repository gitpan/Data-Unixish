package Data::Unixish::pick;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);

our $VERSION = '1.45'; # VERSION

our %SPEC;

$SPEC{pick} = {
    v => 1.1,
    summary => 'Pick one or more random items',
    args => {
        %common_args,
        items => {
            summary => 'Number of items to pick',
            schema=>['int*' => {default=>1}],
            tags => ['main'],
            cmdline_aliases => { n=>{} },
            pos => 0,
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

=encoding UTF-8

=head1 NAME

Data::Unixish::pick - Pick one or more random items

=head1 VERSION

This document describes version 1.45 of Data::Unixish::pick (from Perl distribution Data-Unixish), released on 2014-05-02.

=head1 SYNOPSIS

In Perl:

 use Data::Unixish qw(lduxl);
 my @pick = lduxl([pick => {items=>2}], 1..100); # => (52, 33)

In command line:

 % seq 1 100 | dux pick -n 4
 .-------------------.
 | 18 | 22 |  2 | 24 |
 '----+----+----+----'

=head1 FUNCTIONS


=head2 pick(%args) -> [status, msg, result, meta]

Pick one or more random items.

Arguments ('*' denotes required arguments):

=over 4

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<items> => I<int> (default: 1)

Number of items to pick.

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=back

Return value:

Returns an enveloped result (an array).

First element (status) is an integer containing HTTP status code
(200 means OK, 4xx caller error, 5xx function error). Second element
(msg) is a string containing error message, or 'OK' if status is
200. Third element (result) is optional, the actual result. Fourth
element (meta) is called result metadata and is optional, a hash
that contains extra information.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Data-Unixish>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-Data-Unixish>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=Data-Unixish>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
