package Comparer::file_mtime;

use 5.010001;
use strict 'subs', 'vars';
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

sub meta {
    return +{
        v => 1,
        args => {
            follow_symlink => {schema=>'bool*', default=>1},
            reverse => {schema => 'bool*'},
        },
    };
}

sub gen_comparer {
    my %args = @_;

    my $follow_symlink = $args{follow_symlink} // 1;
    my $reverse = $args{reverse};

    sub {
        my @st1 = $follow_symlink ? stat($_[0]) : lstat($_[0]);
        my @st2 = $follow_symlink ? stat($_[1]) : lstat($_[1]);

        (
            $st1[9] <=> $st2[9]
        ) * ($reverse ? -1 : 1)
    };
}

1;
# ABSTRACT: Compare file's mtime (modification time)

=for Pod::Coverage ^(meta|gen_comparer)$

=head1 SYNOPSIS

 use Comparer::from_sortkey;

 my $cmp = Comparer::file_mtime::gen_comparer();
 my @sorted = sort { $cmp->($a,$b) } "newest", "old", "new";
 # => ("old","new","newest")

 # reverse
 $cmp = Comparer::file_mtime::gen_comparer(reverse => 1);
 @sorted = sort { $cmp->($a,$b) } "newest", "old", "new";
 # => ("newest","new","old")

A real-world usage example (requires CLI L<sort-by-comparer> from
L<App::sort_by_comparer>):

 # find directories named '*.git' that are newer than 7 days, and sort them by newest first
 % find -maxdepth 1 -type d -name '*.git' -mtime -7 | sort-by-comparer file_mtime -r


=head1 DESCRIPTION

This comparer assumes the entries are filenames and will compare their
modification time.


=head1 COMPARER ARGUMENTS

=head2 follow_symlink

Bool, default true. If set to false, will use C<lstat()> function instead of the
default C<stat()>.

=head2 reverse

Bool.


=head1 SEE ALSO

L<Sorter::file_mtime>

L<SortKey::Num::file_by_mtime>

=cut
