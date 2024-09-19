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
            reverse => {schema => 'bool*'},
        },
    };
}

sub gen_comparer {
    my %args = @_;

    my $reverse = $args{reverse};

    sub {
        (
            (-M $_[1]) <=> (-M $_[0])
        ) * ($args{reverse} ? -1 : 1)
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


=head1 DESCRIPTION

This comparer assumes the entries are filenames and will compare their
modification time.


=head1 COMPARER ARGUMENTS

=head2 reverse

Bool.


=head1 SEE ALSO

=cut
