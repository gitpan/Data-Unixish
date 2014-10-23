package Data::Unixish::num;

use 5.010;
use locale;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);
use Number::Format;
use POSIX qw(locale_h);
use Scalar::Util 'looks_like_number';
use SHARYANTO::Number::Util qw(format_metric);

our $VERSION = '1.44'; # VERSION

our %SPEC;

my %styles = (
    general    => 'General formatting, e.g. 1, 2.345',
    fixed      => 'Fixed number of decimal digits, e.g. 1.00, default decimal digits=2',
    scientific => 'Scientific notation, e.g. 1.23e+21',
    kilo       => 'Use K/M/G/etc suffix with base-2, e.g. 1.2M',
    kibi       => 'Use Ki/Mi/GiB/etc suffix with base-10 [1000], e.g. 1.2Mi',
    percent    => 'Percentage, e.g. 10.00%',
    # XXX fraction
    # XXX currency?
);

# XXX negative number -X or (X)
# XXX colorize negative number?
# XXX leading zeros/spaces

$SPEC{num} = {
    v => 1.1,
    summary => 'Format number',
    description => <<'_',

Observe locale environment variable settings.

Undef and non-numbers are ignored.

_
    args => {
        %common_args,
        style => {
            schema=>['str*', in=>[keys %styles], default=>'general'],
            cmdline_aliases => { s=>{} },
            pos => 0,
            description => "Available styles:\n\n".
                join("", map {" * $_  ($styles{$_})\n"} sort keys %styles),
        },
        decimal_digits => {
            summary => 'Number of digits to the right of decimal point',
        },
        thousands_sep => {
            summary => 'Use a custom thousand separator character',
            description => <<'_',

Default is from locale (e.g. dot "." for en_US, etc).

Use empty string "" if you want to disable printing thousands separator.

_
            schema => ['str*'],
        },
        prefix => {
            summary => 'Add some string at the beginning (e.g. for currency)',
            schema => ['str*'],
        },
        suffix => {
            summary => 'Add some string at the end (e.g. for unit)',
            schema => ['str*'],
        },
    },
    tags => [qw/format itemfunc/],
};
sub num {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});

    my $orig_locale = _num_begin(\%args);
    while (my ($index, $item) = each @$in) {
        push @$out, _num_item($item, \%args);
    }
    _num_end(\%args, $orig_locale);

    [200, "OK"];
}

sub _num_begin {
    my $args = shift;

    $args->{style} //= 'general';
    $args->{style} = 'general' if !$styles{$args->{style}};

    $args->{prefix} //= "";
    $args->{suffix} //= "";
    $args->{decimal_digits} //=
        ($args->{style} eq 'kilo' || $args->{style} eq 'kibi' ? 1 : 2);

    my $orig_locale = setlocale(LC_ALL);
    if ($ENV{LC_NUMERIC}) {
        setlocale(LC_NUMERIC, $ENV{LC_NUMERIC});
    } elsif ($ENV{LC_ALL}) {
        setlocale(LC_ALL, $ENV{LC_ALL});
    } elsif ($ENV{LANG}) {
        setlocale(LC_ALL, $ENV{LANG});
    }

    # args abused to store object/state
    my %nfargs;
    if (defined $args->{thousands_sep}) {
        $nfargs{THOUSANDS_SEP} = $args->{thousands_sep};
    }
    $args->{_nf} = Number::Format->new(%nfargs);

    return $orig_locale;
}

sub _num_item {
    my ($item, $args) = @_;

    {
        last if !defined($item) || !looks_like_number($item);
        my $nf      = $args->{_nf};
        my $style   = $args->{style};
        my $decdigs = $args->{decimal_digits};

        if ($style eq 'fixed') {
            $item = $nf->format_number($item, $decdigs, $decdigs);
        } elsif ($style eq 'scientific') {
            $item = sprintf("%.${decdigs}e", $item);
        } elsif ($style eq 'kilo') {
            my $res = format_metric($item, {base=>2, return_array=>1});
            $item = $nf->format_number($res->[0], $decdigs, $decdigs) .
                $res->[1];
        } elsif ($style eq 'kibi') {
            my $res = format_metric(
                $item, {base=>10, return_array=>1});
            $item = $nf->format_number($res->[0], $decdigs, $decdigs) .
                $res->[1];
        } elsif ($style eq 'percent') {
            $item = sprintf("%.${decdigs}f%%", $item*100);
        } else {
            # general
            $item = $nf->format_number($item);
        }
        $item = "$args->{prefix}$item$args->{suffix}";
    }
    return $item;
}

sub _num_end {
    my ($args, $orig_locale) = @_;
    setlocale(LC_ALL, $orig_locale);
}

1;
# ABSTRACT: Format number

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Unixish::num - Format number

=head1 VERSION

version 1.44

=head1 RELEASE DATE

2014-04-24

=head1 SYNOPSIS

In Perl:

 use Data::Unixish qw(lduxl);
 my @res = lduxl([num => {style=>"fixed"}], 0, 10, -2, 34.5, [2], {}, "", undef);
 # => ("0.00", "10.00", "-2.00", "34.50", [2], {}, "", undef)

In command line:

 % echo -e "1\n-2\n" | LANG=id_ID dux num -s fixed --format=text-simple
 1,00
 -2,00

=head1 FUNCTIONS


=head2 num(%args) -> [status, msg, result, meta]

Format number.

Observe locale environment variable settings.

Undef and non-numbers are ignored.

Arguments ('*' denotes required arguments):

=over 4

=item * B<decimal_digits> => I<any>

Number of digits to the right of decimal point.

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=item * B<prefix> => I<str>

Add some string at the beginning (e.g. for currency).

=item * B<style> => I<str> (default: "general")

Available styles:

=over

=item *

fixed  (Fixed number of decimal digits, e.g. 1.00, default decimal digits=2)


=item *

general  (General formatting, e.g. 1, 2.345)


=item *

kibi  (Use Ki/Mi/GiB/etc suffix with base-10 [1000], e.g. 1.2Mi)


=item *

kilo  (Use K/M/G/etc suffix with base-2, e.g. 1.2M)


=item *

percent  (Percentage, e.g. 10.00%)


=item *

scientific  (Scientific notation, e.g. 1.23e+21)


=back

=item * B<suffix> => I<str>

Add some string at the end (e.g. for unit).

=item * B<thousands_sep> => I<str>

Use a custom thousand separator character.

Default is from locale (e.g. dot "." for en_US, etc).

Use empty string "" if you want to disable printing thousands separator.

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
