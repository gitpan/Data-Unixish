package Data::Unixish::sprintf;

use 5.010;
use locale;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);
use POSIX qw(locale_h);
use Scalar::Util 'looks_like_number';

our $VERSION = '1.42'; # VERSION

our %SPEC;

$SPEC{sprintf} = {
    v => 1.1,
    summary => 'Apply sprintf() on input',
    description => <<'_',

Array will also be processed (all the elements are fed to sprintf(), the result
is a single string), unless `skip_array` is set to true.

Non-numbers can be skipped if you use `skip_non_number`.

Undef, hashes, and other non-scalars are ignored.

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
    },
    tags => [qw/format/],
};
sub sprintf {
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
                $item = CORE::sprintf($format, @$item);
                last;
            }
            last if $r;
            last if $item eq '';
            last if !looks_like_number($item) && $args{skip_non_number};
            {
                no warnings;
                $item = CORE::sprintf($format, $item);
            }
        }
        push @$out, $item;
    }

    setlocale(LC_ALL, $orig_locale);

    [200, "OK"];
}

1;
# ABSTRACT: Apply sprintf() on input

__END__

=pod

=encoding utf-8

=head1 NAME

Data::Unixish::sprintf - Apply sprintf() on input

=head1 VERSION

version 1.42

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::List qw(dux);
 my @res = dux([sprintf => {format=>"%.1f"}], 0, 1, [2], {}, "", undef);
 # => ("0.0", "1.0", "2.0", {}, "", undef)

In command line:

 % echo -e "0\n1\n\nx\n" | dux sprintf -f "%.1f" --skip-non-number --format=text-simple
 0.0
 1.0

 x

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 sprintf(%args) -> [status, msg, result, meta]

Array will also be processed (all the elements are fed to sprintf(), the result
is a single string), unless C<skip_array> is set to true.

Non-numbers can be skipped if you use C<skip_non_number>.

Undef, hashes, and other non-scalars are ignored.

Arguments ('*' denotes required arguments):

=over 4

=item * B<format>* => I<str>

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=item * B<skip_array> => I<bool> (default: 0)

=item * B<skip_non_number> => I<bool> (default: 0)

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=head1 SEE ALSO

printf(1)

L<Data::Unixish::sprintfn>

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Data-Unixish>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-Data-Unixish>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
L<https://rt.cpan.org/Public/Dist/Display.html?Name=Data-Unixish>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
