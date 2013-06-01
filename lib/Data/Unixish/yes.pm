package Data::Unixish::yes;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);
our $VERSION = '1.34'; # VERSION

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
    tags => [qw/text/],
    'x.dux.is_stream_output' => 1,
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

=head1 NAME

Data::Unixish::yes - Output a string repeatedly until killed

=head1 VERSION

version 1.34

=head1 SYNOPSIS

In command line:

 % dux yes
 y
 y
 y
 ...

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 FUNCTIONS


=head2 yes() -> [status, msg, result, meta]

No arguments.

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut

