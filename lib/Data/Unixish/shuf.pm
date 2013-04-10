package Data::Unixish::shuf;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
use Log::Any '$log';

use List::Util qw(shuffle);

our $VERSION = '1.28'; # VERSION

our %SPEC;

$SPEC{shuf} = {
    v => 1.1,
    summary => 'Shuffle items',
    args => {
        in  => {schema=>'any'},
        out => {schema=>'any'},
    },
    tags => [qw/ordering/],
};
sub shuf {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});

    my @tmp;
    while (my ($index, $item) = each @$in) {
        push @tmp, $item;
    }

    push @$out, $_ for shuffle @tmp;
    [200, "OK"];
}

1;
# ABSTRACT: Shuffle items



__END__
=pod

=encoding utf-8

=head1 NAME

Data::Unixish::shuf - Shuffle items

=head1 VERSION

version 1.28

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::shuf;
 my $in  = [1, 2, 3];
 my $out = [];
 Data::Unixish::shuf::shuf(in=>$in, out=>$out); # $out = [2, 1, 3]

In command line:

 % echo -e "1\n2\n3" | dux shuf --format=text-simple
 3
 1
 2

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 shuf(%args) -> [status, msg, result, meta]

Shuffle items.

Arguments ('*' denotes required arguments):

=over 4

=item * B<in> => I<any>

=item * B<out> => I<any>

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut

