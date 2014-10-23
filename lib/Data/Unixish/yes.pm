package Data::Unixish::yes;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);
our $VERSION = '1.45'; # VERSION

our %SPEC;

$SPEC{yes} = {
    v => 1.1,
    summary => 'Output a string repeatedly until killed',
    description => <<'_',

This is like the Unix `yes` utility.

_
    args => {
        %common_args,
        string => {
            schema => ['str*', default=>'y'],
            pos    => 0,
            greedy => 1,
        },
    },
    tags => [qw/text gen-data/],
    'x.dux.is_stream_output' => 1, # for duxapp < 1.41, will be removed later
    'x.app.dux.is_stream_output' => 1,
};
sub yes {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});

    my $str = $args{string} // 'y';

    while (1) {
        push @$out, $str;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Output a string repeatedly until killed

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Unixish::yes - Output a string repeatedly until killed

=head1 VERSION

This document describes version 1.45 of Data::Unixish::yes (from Perl distribution Data-Unixish), released on 2014-05-02.

=head1 SYNOPSIS

In command line:

 % dux yes
 y
 y
 y
 ...

=head1 FUNCTIONS


=head2 yes(%args) -> [status, msg, result, meta]

Output a string repeatedly until killed.

This is like the Unix C<yes> utility.

Arguments ('*' denotes required arguments):

=over 4

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=item * B<string> => I<str> (default: "y")

=back

Return value:

Returns an enveloped result (an array).

First element (status) is an integer containing HTTP status code
(200 means OK, 4xx caller error, 5xx function error). Second element
(msg) is a string containing error message, or 'OK' if status is
200. Third element (result) is optional, the actual result. Fourth
element (meta) is called result metadata and is optional, a hash
that contains extra information.

=head1 SEE ALSO

yes(1)

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
