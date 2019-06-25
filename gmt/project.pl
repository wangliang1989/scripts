#!/usr/bin/env perl
use strict;
use warnings;

my $xy = "6 7";
my $start = "2 7";#测线起点
my $end = 5;#测线长度
my $az=150;#测线方位角
my $font_pqrs = "15p,7,blue";

my ($x, $y) = split m/\s+/, $xy;
my ($start_x, $start_y) = split m/\s+/, $start;
my ($p, $q, $r, $s) = split m/\s+/, `echo $xy | gmt project -C$start_x/$start_y -A$az -L0/7 -Fpqrs`;#得到pqrs
system "gmt begin";
system "gmt figure GMT_linear png A0.2c";
my $az_pq = 270 - $az;
system "gmt basemap -R0/7/0/5 -JX7c/5c -Bws --MAP_FRAME_TYPE=graph -p$az_pq/90+v${start_x}/${start_y}+w0/0";#绘制PQ坐标系
&gmt("gmt text -F+f12p,5,black -p$az_pq/90+v${start_x}/${start_y}+w0/0 -D0c/0.4c -N", "7 0 P");#标注P
&gmt("gmt text -F+f12p,5,black -p$az_pq/90+v${start_x}/${start_y}+w0/0 -D0.4c/0c -N", "0 5 Q");#标注Q
&gmt("gmt plot -W1p,black,- -p$az_pq/90+v${start_x}/${start_y}+w0/0", "0 $q", "$p $q");#绘制xy到Q轴的虚线

system "gmt basemap -R0/10/0/10 -JX10c -Bws --MAP_FRAME_TYPE=graph -p180/90";#绘制大坐标系
my @surveying = split m/\n/, `gmt project -C$start_x/$start_y -A$az -G1 -L0/$end`;#测线上的点
my ($subpoint) = split m/\n/, `echo $xy | gmt project -C$start_x/$start_y -A$az -L0/7 -Frs`;#得到投影点
my ($subpoint_x, $subpoint_y) = split m/\s+/, $subpoint;
&gmt("gmt plot -W5p,green", @surveying);#绘制测线

&gmt("gmt text -F+f$font_pqrs -D0/-0.3c -N", "$subpoint_x 0 r");#标注r
&gmt("gmt text -F+f$font_pqrs -D-0.3c/0 -N", "0 $subpoint_y s");#标注s
&gmt("gmt text -F+f12p,5,black -D0c/-0.2c -N", "11 0 X");#绘制标注X
&gmt("gmt text -F+f12p,5,black -D-0.2c/0c -N", "0 11 Y");#绘制标注Y
&gmt("gmt plot -W1p,black,-", $xy, $subpoint);#xy到投影点的虚线
&gmt("gmt plot -W1p,black,-", $subpoint, "$subpoint_x 0");#投影点到r的虚线
&gmt("gmt plot -W1p,black,-", $subpoint, "0 $subpoint_y");#投影点到s的虚线
&gmt("gmt plot -W1p,black -Sqn1:+Lh+f$font_pqrs+n0c/0.5c -p$az_pq/90+v${start_x}/${start_y}+w0/0", '> -L\q', "0 0", "0 $q");#绘制q的蓝色长度指示线
&gmt("gmt plot -W1p,green -Sqn1:+Lh+f$font_pqrs+n0c/-0.5c -p$az_pq/90+v${start_x}/${start_y}+w0/0", '> -L\p', "0 0", "$p 0");#绘制p的蓝色长度指示线
&gmt("gmt plot -W1p,blue -Sv0.5c+s+et+bt -p$az_pq/90+v${start_x}/${start_y}+w0/0 -N", "0 -0.25 $p -0.25");#绘制q的蓝色长度指示线
&gmt("gmt plot -W1p,blue -Sv0.5c+s+et+bt -p$az_pq/90+v${start_x}/${start_y}+w0/0 -N", "-0.25 0 -0.25 $q");#绘制q的蓝色长度指示线
&gmt("gmt plot -Sc0.2c -W1p,darkblue -Gpurple", $subpoint);#绘制投影点
&gmt("gmt plot -Sc0.3c -W1p,darkblue -Gred", $xy);#绘制xy
&gmt("gmt text -F+f$font_pqrs -D0.8c/0.2c", "$xy (x, y)");#标注xy
&gmt("gmt plot -Sc0.2c -W1p,darkblue -Gdodgerblue", $start);#绘制起點
&gmt("gmt plot -Sc0.2c -W1p,darkblue -Gyellow", pop @surveying);#绘制起點
system "gmt end";

sub gmt {
    my @in = @_;
    my $cmd = shift @in;
    open (GMT, "| $cmd") or die;
    foreach (@in) {
        print GMT "$_\n";
    }
    close(GMT);
}
