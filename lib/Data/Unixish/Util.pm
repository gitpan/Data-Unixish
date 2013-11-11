package Data::Unixish::Util;

our $VERSION = '1.42'; # VERSION

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(%common_args);

our %common_args = (
    in  => {
        summary => 'Input stream (e.g. array or filehandle)',
        schema  => 'any', # TODO: any* => of => [stream*, array*]
        #req => 1,
    },
    out => {
        summary => 'Output stream (e.g. array or filehandle)',
        schema  => 'any', # TODO: any* => of => [stream*, array*]
        #req => 1,
    },
);

1;
#ABSTRACT: Utility routines

__END__

=pod

=encoding utf-8

=head1 NAME

Data::Unixish::Util - Utility routines

=head1 VERSION

version 1.42

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

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
