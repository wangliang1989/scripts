#!/usr/bin/env perl
use strict;
use warnings;

my $targit = '/run/media/peterpan/Passport';
my $oldday = 9999999;
my $newday = `date '+%Y%j'`;
my $whoami = `whoami`;
chomp($newday);
chomp($whoami);

chdir $targit;

foreach (glob("backup-*")) {
    my (undef, $tempday) = split /-/;
    if ($tempday < $oldday) {
        $oldday = $tempday;
    }
}
system "rsync -a --delete --progress /home/$whoami $targit/backup-$oldday";
system "mv $targit/backup-$oldday $targit/backup-$newday";
