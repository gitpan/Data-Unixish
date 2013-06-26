package Data::Unixish::sprintfn;

use 5.010;
use locale;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);
use POSIX qw(locale_h);
use Scalar::Util 'looks_like_number';
use Text::sprintfn ();

our $VERSION = '1.37'; # VERSION

our %SPEC;

$SPEC{sprintfn} = {
    v => 1.1,
    summary => 'Like sprintf, but use sprintfn() from Text::sprintfn',
    description => <<'_',

Unlike in *sprintf*, with this function, hash will also be processed.

_
    args => {
        %common_args,
        format => {
            schema=>['str*'],
            cmdline_aliases => { f=>{} },
            req => 1,
            pos => 0,
        },
        skip_non_number => {
            schema=>[bool => default=>0],
        },
        skip_array => {
            schema=>[bool => default=>0],
        },
        skip_hash => {
            schema=>[bool => default=>0],
        },
    },
    tags => [qw/format/],
};
sub sprintfn {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $format = $args{format};

    my $orig_locale = setlocale(LC_ALL);
    if ($ENV{LC_NUMERIC}) {
        setlocale(LC_NUMERIC, $ENV{LC_NUMERIC});
    } elsif ($ENV{LC_ALL}) {
        setlocale(LC_ALL, $ENV{LC_ALL});
    } elsif ($ENV{LANG}) {
        setlocale(LC_ALL, $ENV{LANG});
    }

    while (my ($index, $item) = each @$in) {
        {
            last unless defined($item);
            my $r = ref($item);
            if ($r eq 'ARRAY' && !$args{skip_array}) {
                no warnings;
                $item = Text::sprintfn::sprintfn($format, @$item);
                last;
            }
            if ($r eq 'HASH' && !$args{skip_hash}) {
                no warnings;
                $item = Text::sprintfn::sprintfn($format, $item);
                last;
            }
            last if $r;
            last if $item eq '';
            last if !looks_like_number($item) && $args{skip_non_number};
            {
                no warnings;
                $item = Text::sprintfn::sprintfn($format, $item);
            }
        }
        push @$out, $item;
    }

    setlocale(LC_ALL, $orig_locale);

    [200, "OK"];
}

1;
# ABSTRACT: Like sprintf, but use sprintfn() from Text::sprintfn



__END__
=pod

=encoding utf-8

=head1 NAME

Data::Unixish::sprintfn - Like sprintf, but use sprintfn() from Text::sprintfn

=head1 VERSION

version 1.37

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::List qw(dux);
 my @res = dux([sprintfn => {format=>"%(n).1f"}], {n=>1}, {n=>2}, "", undef);
 # => ("1.0", "2.0", "", undef)

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 sprintfn(%args) -> [status, msg, result, meta]

Like sprintf, but use sprintfn() from Text::sprintfn.

Unlike in I<sprintf>, with this function, hash will also be processed.

Arguments ('*' denotes required arguments):

=over 4

=item * B<format>* => I<str>

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=item * B<skip_array> => I<bool> (default: 0)

=item * B<skip_hash> => I<bool> (default: 0)

=item * B<skip_non_number> => I<bool> (default: 0)

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut

