package Data::Unixish::cat;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
use Log::Any '$log';

our $VERSION = '1.28'; # VERSION

our %SPEC;

$SPEC{cat} = {
    v => 1.1,
    summary => 'Pass input unchanged',
    args => {
        in  => {schema=>'any'},
        out => {schema=>'any'},
    },
    tags => [qw/filtering/],
};
sub cat {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});

    while (my ($index, $item) = each @$in) {
        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Pass input unchanged



__END__
=pod

=encoding utf-8

=head1 NAME

Data::Unixish::cat - Pass input unchanged

=head1 VERSION

version 1.28

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::cat;
 my $in  = [1, 2, 3];
 my $out = [];
 Data::Unixish::cat::cat(in=>$in, out=>$out); # $out = [1, 2, 3]

In command line:

 % echo -e "1\n2\n3" | dux cat --format=text-simple
 1
 2
 3

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 cat(%args) -> [status, msg, result, meta]

Pass input unchanged.

Arguments ('*' denotes required arguments):

=over 4

=item * B<in> => I<any>

=item * B<out> => I<any>

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut

