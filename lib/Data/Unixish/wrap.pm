package Data::Unixish::wrap;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Text::Wrap ();

our $VERSION = '1.26'; # VERSION

our %SPEC;

$SPEC{wrap} = {
    v => 1.1,
    summary => 'Wrap text',
    description => <<'_',

Currently implemented using Text::Wrap standard Perl module.

_
    args => {
        in  => {schema=>'any'},
        out => {schema=>'any'},
        columns => {
            summary => 'Target column width',
            schema =>[int => {default=>80, min=>1}],
            cmdline_aliases => { c=>{} },
        },
    },
    tags => [qw/text/],
};
sub wrap {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $cols = $args{columns} // 80;

    local $Text::Wrap::columns = $cols;

    while (my ($index, $item) = each @$in) {
        my @lt;
        if (defined($item) && !ref($item)) {
            $item = Text::Wrap::wrap("", "", $item);
        }

        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Wrap text



__END__
=pod

=head1 NAME

Data::Unixish::wrap - Wrap text

=head1 VERSION

version 1.26

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::wrap;
 my $in  = ["xxxx xxxx xxxx xxxx xxxx"];
 my $out = [];
 Data::Unixish::wrap::wrap(in=>$in, out=>$out, columns => 20);
 # $out = ["xxxx xxxx xxxx xxxx\nxxxx"]

In command line:

 % echo -e "xxxx xxxx xxxx xxxx xxxx" | dux rtrim -c 20
 xxxx xxxx xxxx xxxx
 xxxx

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

=head2 wrap(%args) -> [status, msg, result, meta]

Wrap text.

Currently implemented using Text::Wrap standard Perl module.

Arguments ('*' denotes required arguments):

=over 4

=item * B<columns> => I<int> (default: 80)

Target column width.

=item * B<in> => I<any>

=item * B<out> => I<any>

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut

