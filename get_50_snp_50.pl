#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long;

my $name; #�����ļ�����һ��ΪȾɫ�壬�ڶ���ΪSNPλ��
my $len = 50; #λ�������γ���,Ĭ�� 50 bp

GetOptions(
	'i=s' => \$name,
	'l=i' => \$len,
	'h|help' => \&Usage,
);


open IN,"$name"; #�����ļ�����һ��ΪȾɫ�壬�ڶ���ΪSNPλ��
open OUT,">$name.tmp.bed"; #��ʱ�����bed��ʽ�ļ�

#��SNP������ָ���ĳ�������bed�ļ�
while (<IN>) {
	chomp;
	my @a = split/\s+/;
	print OUT "$a[0]\t",($a[1]-$len-1),"\t",($a[1]+$len),"\t$a[0]-$a[1]\n";
}
close IN;

#����bedtools�����ȡ����
system"bedtools getfasta -fi /mnt/d/genome/B73/Zea_mays.B73_RefGen_v4.dna.toplevel.fa -bed $name.tmp.bed -fo $name.tmp.fa -name";

#��SNPλ����[]���
open IN,"$name.tmp.fa";
open OUT,">$name.result.txt";

local $/ = ">";

<IN>;
while (<IN>) {
	chomp;
	my @a = split/\n/;
	my @b = split//,$a[1];
	print OUT "$a[0]\t";
	foreach  (0..$len-1) {
		print OUT "$b[$_]";
	}
	print OUT '[',$b[$len],']';
	foreach  ($len+1..$#b) {
		print OUT "$b[$_]";
	}
	print OUT "\n";
}
close IN;
close OUT;


sub Usage {
	print <<USAGE;
	Usage:
		perl $0 -i <input_file> -l [length]
		i	STR	input text file, such as line1 "chromosome	position"
		l	INT	spefic the length of upstream and downstream, [50]
		h|help		help information
	Before running the perl script, you need to install the bedtools.
USAGE
	exit;
}