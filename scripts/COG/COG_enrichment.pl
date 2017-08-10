#!/usr/bin/perl -w
use strict;
use File::Basename;
use  Comparison;

my @list=<*_differential.xls>;
foreach my $file(@list){
open DIFF, $file;
my ($name1,$name2);
if($file=~/(\S+)_differential\.xls/){
        $name1=$1;
        
    }
my $out_name=$name1;
my $out=$out_name."_COG_enrichment.xls";

open  OUT , ">$out";
my (%all_COG,%diff_COG,%info_COG,%gene2COG,%gene,%diff_gene_list,%all_gene2COG)=();
my $num=0;
my $all=0;
my (%up,%down)=();
while(<DIFF>){
    chomp;
	next if /gene_id/;
    my @tmp=split "\t";
     $gene{$tmp[0]}=1;
    
}
close DIFF;
open COG,$ARGV[0];
my %test=();

while(<COG>){
    chomp;
   my @ls=split "\t";
   next if /COG/;
   next unless $ls[1];
   if(exists $test{$ls[0].$ls[1]}){
      next;
   }else{
      $test{$ls[0].$ls[1]}=1;
   }
    $all_gene2COG{$ls[0]}=1;
    $all_COG{$ls[1]}++;
    
    if(exists $gene{$ls[0]})
    {
        $gene2COG{$ls[0]}=1;
        $diff_COG{$ls[1]}++;
		
        $diff_gene_list{$ls[1]}.=$ls[0].',';        
    }   
    $info_COG{$ls[1]}=$ls[2];
}
     $num=keys %gene2COG;
     $all=keys %all_gene2COG;
print OUT  'COG_type',"\t",'descript',"\t",'diff_gene_in_this_COG',"\t",'all_diff_gene_in_all_COG',"\t",'all_gene_in_this_COG',"\t",'all_gene_in_all_COG',"\t",'gene_list',"\t",'Enrich_factor',"\t",'Pvalue',"\t",'Qvalue',"\n";
my  (%p_value,%last,%factor)=();
my $index=0;
my $count=0;
my  ($gene_list,$downs);
foreach  my $dg(keys %diff_COG){   
    my  $p=Comparison::calculate_significance($diff_COG{$dg}, $all_COG{$dg},$num,$all);   
        $p_value{$dg}=$p;
	my $factor=($diff_COG{$dg}/$all_COG{$dg})/($num/$all);
        if($factor<1){
	  $p_value{$dg}='-';
      }
        $last{$dg}=$dg."\t".$info_COG{$dg}."\t".$diff_COG{$dg}."\t".$num."\t".$all_COG{$dg}."\t".$all."\t".$diff_gene_list{$dg}."\t".$factor."\t".$p;
        $factor{$dg}=$factor;
}
my  $n=keys %p_value;
my $temp=-1;
foreach my $eg(sort {$p_value{$a} <=> $p_value{$b}} keys %p_value){
        $count++;
		if($p_value{$eg} eq '-') {next}
        if($p_value{$eg} != $temp){
        my $fdr =$p_value{$eg}*$n/$count;	
	if($fdr>1){
            $fdr=1;
            }
        print OUT  $last{$eg},"\t",$fdr,"\n";       
		$index++;
        }else{
        my $fdr =$p_value{$eg}*$n/$index;
	 if($fdr>1){
            $fdr=1;
            } 	
        print OUT  $last{$eg},"\t",$fdr,"\n";       
		}
        $temp=$p_value{$eg};
        
}
close COG;
close OUT;
print  "Bar plot...................\n";
my $gn=$out_name.'_COG_enrichment';
system("Rscript COG_enrichment.R $out  $gn");
}
