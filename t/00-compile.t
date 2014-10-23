use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.037

use Test::More  tests => 40 + ($ENV{AUTHOR_TESTING} ? 1 : 0);



my @module_files = (
    'Data/Unixish.pm',
    'Data/Unixish/Apply.pm',
    'Data/Unixish/List.pm',
    'Data/Unixish/Util.pm',
    'Data/Unixish/_pad.pm',
    'Data/Unixish/avg.pm',
    'Data/Unixish/bool.pm',
    'Data/Unixish/cat.pm',
    'Data/Unixish/centerpad.pm',
    'Data/Unixish/date.pm',
    'Data/Unixish/grep.pm',
    'Data/Unixish/head.pm',
    'Data/Unixish/indent.pm',
    'Data/Unixish/lc.pm',
    'Data/Unixish/lcfirst.pm',
    'Data/Unixish/lins.pm',
    'Data/Unixish/linum.pm',
    'Data/Unixish/lpad.pm',
    'Data/Unixish/ltrim.pm',
    'Data/Unixish/map.pm',
    'Data/Unixish/num.pm',
    'Data/Unixish/pick.pm',
    'Data/Unixish/rev.pm',
    'Data/Unixish/rins.pm',
    'Data/Unixish/rpad.pm',
    'Data/Unixish/rtrim.pm',
    'Data/Unixish/shuf.pm',
    'Data/Unixish/sort.pm',
    'Data/Unixish/sprintf.pm',
    'Data/Unixish/sprintfn.pm',
    'Data/Unixish/sum.pm',
    'Data/Unixish/tail.pm',
    'Data/Unixish/trim.pm',
    'Data/Unixish/trunc.pm',
    'Data/Unixish/uc.pm',
    'Data/Unixish/ucfirst.pm',
    'Data/Unixish/wc.pm',
    'Data/Unixish/wrap.pm',
    'Data/Unixish/yes.pm',
    'Test/Data/Unixish.pm'
);



# no fake home requested

my $inc_switch = -d 'blib' ? '-Mblib' : '-Ilib';

use File::Spec;
use IPC::Open3;
use IO::Handle;

my @warnings;
for my $lib (@module_files)
{
    # see L<perlfaq8/How can I capture STDERR from an external command?>
    open my $stdin, '<', File::Spec->devnull or die "can't open devnull: $!";
    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, $inc_switch, '-e', "require q[$lib]");
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($?, 0, "$lib loaded ok");

    if (@_warnings)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};


