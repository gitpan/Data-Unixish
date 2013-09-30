package Data::Unixish::map;

use 5.010;
use locale;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);

our $VERSION = '1.39'; # VERSION

our %SPEC;

$SPEC{map} = {
    v => 1.1,
    summary => 'Perl map',
    description => <<'_',

Process each item through a callback.

_
    args => {
        %common_args,
        callback => {
            summary => 'The callback coderef to use',
        },
    },
    tags => [qw//],
};
sub map {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $callback = $args{callback} or die "missing callback for map";

    local ($., $_);
    while (($., $_) = each @$in) {
        push @$out, $callback->();
    }

    [200, "OK"];
}

1;
# ABSTRACT: Perl map

__END__

=pod

=encoding utf-8

=head1 NAME

Data::Unixish::map - Perl map

=head1 VERSION

version 1.39

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::List qw(dux);
 my @res = dux([map => {callback => sub { 1 + $_ }}], 1, 2, 3);
 # => (2, 3, 4)

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 map(%args) -> [status, msg, result, meta]

Process each item through a callback.

Arguments ('*' denotes required arguments):

=over 4

=item * B<callback> => I<any>

The callback coderef to use.

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut
