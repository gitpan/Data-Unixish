package Data::Unixish::Util;

our $VERSION = '1.46'; # VERSION

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(%common_args filter_args);

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

sub filter_args {
    my $hash = shift;
    return { map {$_=>$hash->{$_}} grep {/\A\w+\z/} keys %$hash };
}

1;
#ABSTRACT: Utility routines

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Unixish::Util - Utility routines

=head1 VERSION

This document describes version 1.46 of Data::Unixish::Util (from Perl distribution Data-Unixish), released on 2014-05-05.

=head1 EXPORTS

C<%common_args>

=head1 FUNCTIONS

=head2 filter_args

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
