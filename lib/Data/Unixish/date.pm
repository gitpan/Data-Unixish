package Data::Unixish::date;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
use Log::Any '$log';
use POSIX qw(strftime);
use Scalar::Util qw(looks_like_number blessed);

our $VERSION = '1.28'; # VERSION

our %SPEC;

$SPEC{date} = {
    v => 1.1,
    summary => 'Format date',
    description => <<'_',

_
    args => {
        in  => {schema=>'any'},
        out => {schema=>'any'},
        format => {
            summary => 'Format',
            schema=>[str => {default=>0}],
            cmdline_aliases => { f=>{} },
        },
        # tz?
    },
    tags => [qw/format/],
};
sub date {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $format  = $args{format} // '%Y-%m-%d %H:%M:%S';

    while (my ($index, $item) = each @$in) {
        my @lt;
        if (looks_like_number($item) &&
                $item >= 0 && $item <= 2**31) { # XXX Y2038-bug
            @lt = localtime($item);
        } elsif (blessed($item) && $item->isa('DateTime')) {
            # XXX timezone!
            @lt = localtime($item->epoch);
        } else {
            goto OUT_ITEM;
        }

        $item = strftime $format, @lt;

      OUT_ITEM:
        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Format date



__END__
=pod

=encoding utf-8

=head1 NAME

Data::Unixish::date - Format date

=head1 VERSION

version 1.28

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::date;
 my $in  = [DateTime->new(year=>2012, month=>9, day=>6), 1290380232, "foo"];
 my $out = [];
 Data::Unixish::date::date(in=>$in, out=>$out, format=>"%Y-%m-%d");
 # $out = ["2012-09-06","2010-11-22","foo"]

In command line:

 % echo -e "1290380232\nfoo" | dux date --format=text-simple
 2010-11-22 05:57:12
 foo

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 date(%args) -> [status, msg, result, meta]

Format date.

Arguments ('*' denotes required arguments):

=over 4

=item * B<format> => I<str> (default: 0)

Format.

=item * B<in> => I<any>

=item * B<out> => I<any>

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut

