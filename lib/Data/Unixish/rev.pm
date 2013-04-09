package Data::Unixish::rev;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
use Log::Any '$log';

our $VERSION = '1.27'; # VERSION

our %SPEC;

$SPEC{rev} = {
    v => 1.1,
    summary => 'Reverse items',
    args => {
        in  => {schema=>'any'},
        out => {schema=>'any'},
    },
    tags => [qw/ordering/],
};
sub rev {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});

    my @tmp;
    while (my ($index, $item) = each @$in) {
        push @tmp, $item;
    }

    push @$out, pop @tmp while @tmp;
    [200, "OK"];
}

1;
# ABSTRACT: Reverse items



__END__
=pod

=head1 NAME

Data::Unixish::rev - Reverse items

=head1 VERSION

version 1.27

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::rev;
 my $in  = [1, 2, 3];
 my $out = [];
 Data::Unixish::rev::rev(in=>$in, out=>$out); # $out = [3, 2, 1]

In command line:

 % echo -e "1\n2\n3" | dux rev --format=text-simple
 3
 2
 1

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DESCRIPTION


This module has L<Rinci> metadata.

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 rev(%args) -> [status, msg, result, meta]

Reverse items.

Arguments ('*' denotes required arguments):

=over 4

=item * B<in> => I<any>

=item * B<out> => I<any>

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut

