#!/usr/bin/env perl
#最后一次编写：2016年2月10日
use strict;
use warnings;

my $in = 'sync';# 指定同步对象的文件名
my $target = '/run/media/peterpan/Elements/rsync';# 同步目标
my $errfile = "sync.err";# 错误输出文件

my @source;# 指定的文件中要求同步的对象
my @real = glob"*";# 真实存在的对象
my @lost;# 指定了但实际不存在的对象
my @surprise;# 没有指定但存在的对象
my @sync;# 会进行同步的对象

open(IN, "< $in") or die "$!\n";
foreach (<IN>) {
    chomp($_);
    push @source,$_
}
close(IN);

foreach (@source) {
    if ($_ ~~ @real) {
        push @sync,$_;
    }else{
        push @lost,$_;
    }
}
if (@lost) {
    print "严重错误！如下计划备份内容并不存在:\n";
    foreach (@lost) {
        print "$_\n";
    }
}else{
    foreach (@real) {
        unless ($_ ~~ @source) {
            push @surprise,$_
        }
    }
    if (@surprise) {
        print "警告！一些内容不在计划备份之列:\n";
        foreach (@surprise) {
            print "$_\n";
        }
    }
    print"是否执行备份？y?\n";
    my $do = <STDIN>;
    chomp($do);
    if ($do eq 'y'){
        if (-e $errfile) {
            unlink $errfile;
        }
        open(my $out, '>>', "./$errfile") or die "Could not open file $!";
        foreach (@sync) {
            printf $out "%s","###$_\n";
            $_ =~ s/\s+/\\ /;#$a =~ s/(\s+)/\\$1/;
            system "rsync -a --delete --progress ./$_ $target 2>>$errfile";
        }
        close ($out);
        open(IN, "< $errfile") or die "无法打开STERR文件\n";
        my $errnum = 0;
        foreach (<IN>) {
            if (index($_,'###') == -1) {
                $errnum++;
                print "错误：$_";
            }
        }
       if ($errnum == 0) {print "同步正常结束\n";}
       close(IN);
    }
}
