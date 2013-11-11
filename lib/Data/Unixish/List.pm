package Data::Unixish::List;

use 5.010;
use strict;
use warnings;
#use Log::Any '$log';

use Data::Unixish;

our $VERSION = '1.42'; # VERSION

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(dux);

sub dux { goto &Data::Unixish::lduxl }

1;
# ABSTRACT: (DEPRECATED) Apply dux function to list (and return result as list)

__END__

=pod

=encoding utf-8

=head1 NAME

Data::Unixish::List - (DEPRECATED) Apply dux function to list (and return result as list)

=head1 VERSION

version 1.42

=head1 SYNOPSIS

 # Deprecated, please use lduxl function in Data::Unixish instead.

=head1 DESCRIPTION

=head1 FUNCTIONS

=head2 dux($func, @input) => LIST (OR SCALAR)


None are exported by default, but they are exportable.

=head1 SEE ALSO

L<Data::Unixish>

L<Data::Unixish::Apply>

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
