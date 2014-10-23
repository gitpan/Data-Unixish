package Data::Unixish::avg;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);
use Scalar::Util 'looks_like_number';

our $VERSION = '1.44'; # VERSION

our %SPEC;

$SPEC{avg} = {
    v => 1.1,
    summary => 'Average numbers',
    args => {
        %common_args,
    },
    tags => [qw/group/],
};
sub avg {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});

    my $sum = 0;
    my $n = 0;
    while (my ($index, $item) = each @$in) {
        $n++;
        $sum += $item if looks_like_number($item);
    }

    my $avg = $n ? $sum/$n : 0;

    push @$out, $avg;
    [200, "OK"];
}

1;
# ABSTRACT: Average numbers

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Unixish::avg - Average numbers

=head1 VERSION

version 1.44

=head1 RELEASE DATE

2014-04-24

=head1 SYNOPSIS

In Perl:

 use Data::Unixish qw(lduxl);
 my $avg = lduxl('avg', 1, 2, 3, 4, 5); # => 3

In command line:

 % seq 0 100 | dux avg
 .----.
 | 50 |
 '----'

=head1 FUNCTIONS


=head2 avg(%args) -> [status, msg, result, meta]

Average numbers.

Arguments ('*' denotes required arguments):

=over 4

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

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
