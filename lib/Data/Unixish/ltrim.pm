package Data::Unixish::ltrim;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);

our $VERSION = '1.34'; # VERSION

our %SPEC;

$SPEC{ltrim} = {
    v => 1.1,
    summary => 'Strip whitespace at the beginning of each line of text',
    description => <<'_',

_
    args => {
        %common_args,
        strip_newline => {
            summary => 'Whether to strip newlines at the beginning of text',
            schema =>[bool => {default=>0}],
            cmdline_aliases => { nl=>{} },
        },
    },
    tags => [qw/text/],
};
sub ltrim {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $nl  = $args{nl} // 0;

    while (my ($index, $item) = each @$in) {
        my @lt;
        if (defined($item) && !ref($item)) {
            $item =~ s/\A[\r\n]+// if $nl;
            $item =~ s/^[ \t]+//mg;
        }

        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Strip whitespace at the beginning of each line of text



__END__
=pod

=head1 NAME

Data::Unixish::ltrim - Strip whitespace at the beginning of each line of text

=head1 VERSION

version 1.34

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::List qw(dux);
 my @res = dux('ltrim', "x", "   a", "  b\n   c\n", undef, [" d"]);
 # => ("x", "a", "b\nc\n", undef, [" d"])

In command line:

 % echo -e "x\n  a" | dux ltrim
 x
 a

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 FUNCTIONS


=head2 ltrim() -> [status, msg, result, meta]

No arguments.

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut

