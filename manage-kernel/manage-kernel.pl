#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;

@ARGV == 1 or die "Usage: perl $0 num\n";
# 输入参数为额外保留的核心数，程序设计为必须为0到2的数字，0意味着不保留额外的核心，不超过2是因为保留过多的核心也没有意义。
my ($num) = @ARGV;
$num =~ /[0-2]/ or die "wrong input\n"; 

sub isort{#比较两个版本号，返回更新的
    my ($a,$b) = @_;# 这是输入列表
    my $isort;# 这是返回值

	my ($aa,$ab) = split/-/,$a;
	my ($a1,$a2,$a3) = split/\./,$aa;
	my ($a4,$a5,$a6) = split/\./,$ab;

	my ($ba,$bb) = split/-/,$b;
    my ($b1,$b2,$b3) = split/\./,$ba;
	my ($b4,$b5,$b6) = split/\./,$bb;

	my @teama = ($a1,$a2,$a3,$a4,$a5,$a6);
	my @teamb = ($b1,$b2,$b3,$b4,$b5,$b6);

	my $i;
	for ($i=0;$i<=5;$i++) {# 从左到右依次比较，当有不同时即比较出谁版本号更大，版本号大的更新
	    if ($teama[$i] > $teamb[$i]){
		    $isort = $a;
			last;
		}elsif ($teama[$i] < $teamb[$i]) {
		    $isort = $b;
			last;
		}
	}
	return $isort;
}
print "check kernel.....";
# 获取正在使用的核心版本号，类似于：3.10.0-327.4.5.el7.x86_64
my ($usekernel) = `uname -r`;
print ".....";
# 获取所用带kernel字符的包名称
my @getkernel = `rpm -qa | grep kernel | sort`;
# 第一个字符串为kernel的才是核心，核心的包名称放到数组allkernel中，包名称类似于：kernel-3.10.0-327.4.5.el7.x86_64
my @allkernel;
foreach (@getkernel) {
    my ($word) = split /-/,$_;
	if ($word eq 'kernel') {
	    push @allkernel,$_;
	}
}
print "finished\nkernel used now:\n=========\n$usekernel=========\n\nall kernels:\n=========\n";
my @main;
# 从包名称中提取版本号，保存至main数组，类似于3.10.0-327.4.5.el7.x86_64
foreach (@allkernel) { 
    print $_;
    my (undef,$one,$two) = split/-/,$_;
    unless ($one =~ /[a-z]/i) {
		# 第二个字符串不是字母的，才会从中提取版本号
		# 这样做的目的是排除kernel-devel-这些包。因为kernel-这些包已包含所有版本号，只用kernel-这样的包可以保证main数组内的版本号不漏不重复
		my $str = $one.'-'.$two;
        push @main,$str;
    }
}
# 对main数组元素排序，新的核心在前
my $i = 0;
my $master = 'false';
while ($master eq 'false') {#使用冒泡算法排序
	$master = 'true';
    for ($i=0;$i<=$#main - 1;$i++) {
		my $j = $i + 1;
	    my $new = isort ($main[$i],$main[$j]);#比较两个版本号
		if ($new ne $main[$i]) {#如果较新的不在前，就调换次序
	        $main[$j] = $main[$i];
			$main[$i] = $new;
			$master = 'false';#如果出现调换次序，则需要再遍历一次
		}
	}
}

$i = 0;
my @keep;
# 如果要额外保留的核心数目已经超过main数组最后一个元素的下标，则修改要保留的数目为最后一个元素的下标
if ($num > $#main) {
    $num = $#main;
}
# 把main内的元素存放到keep数组直到元素下标于要额外保留的核心数相等
while ($i <= $num) {
    push @keep,$main[$i];
    $i++;
}
# 根据要保留的核心版本号(存放在keep数组)和所有核心文件(存放在allkernel数组)确定要删除的核心文件，并存放到delet数组
my @delet;
foreach (@allkernel) {
    my $j = 0;
    my $try = $_;
    foreach (@keep) {
        if ((index($try,$_)) != -1) {
            $j = 1;
        }
    }
    if ($j == 0) {
        push @delet,$_;
    }
}
foreach (@delet) {# 检查要删除的核心文件是否为正在使用的，如果有，报警，终止程序，代码需要修正。
    unless ((index($_,$usekernel)) == -1) {
        die "terribe wrong\n";
    }
}
if (@delet > 0){# 如果有要删除的核心，则提示用户删除
    print "\nto delet:\n=========\n";
    foreach (@delet){
        print $_;
    }
    print "=========\nsure to delet?y or n\n";
    for ($i = 1;$i <= 5;$i++){
        my $j = <STDIN>;
        chomp ($j);
        if (($j eq 'y') or ($j eq 'Y')){
            foreach (@delet){
                system "sudo yum remove $_\n";
            }
            print "done\n";
            last;
        }elsif (($j eq 'n') or ($j eq 'N')){
            print "Nothing changed\n";
            last;
        }
        if ($i == 5){
            print "you idiot,goodbye\n";
        }else{
            print "type y or n\n";
        }
    }
}else{
    print "\nNo extra kernels to delet.\n";
}
