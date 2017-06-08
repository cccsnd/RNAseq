#!/usr/bin/perl -w
use strict;
use File::Basename;
use  Comparison;

my @list=<*.txt>;
foreach my $file(@list){
open DIFF, $file;
my ($name1,$name2);
if($file=~/(\S+).txt/){
        $name1=$1;
        
    }
my $out_name=$name1;
my $out=$out_name."_GO_enrichment.xls";

open  OUT , ">${name1}_GO_enrichment.xls";
open  OUT1 , ">${name1}_GO_enrichment.tmp";
my (%all_go,%diff_go,%info_go,%gene2go,%gene,%diff_gene_list,%all_gene2go)=();
my $num=0;
my $all=0;
my (%up,%down)=();
while(<DIFF>){
    chomp;
	next if /^#/;
    my @tmp=split "\t";
     $gene{$tmp[0]}=1;
    
}
close DIFF;
open GO,$ARGV[0];
my %test=();
while(<GO>){
    chomp;
   my @ls=split "\t";
   next if /GO domain/;
   next unless $ls[1];
   if(exists $test{$ls[0].$ls[1]}){
      next;
   }else{
      $test{$ls[0].$ls[1]}=1;
   }
    $all_gene2go{$ls[0]}=1;
    $all_go{$ls[1]}++;
    
    if(exists $gene{$ls[0]})
    {
        $gene2go{$ls[0]}=1;
        $diff_go{$ls[1]}++;
		
        $diff_gene_list{$ls[1]}.=$ls[0].',';
        
    }
    $ls[3]=~s/Process/biological_process/;
    $ls[3]=~s/Component/cellular_component/;
      $ls[3]=~s/Function/molecular_function/;
    $info_go{$ls[1]}=$ls[2]."\t".$ls[3];
   
    
}
     $num=keys %gene2go;
     $all=keys %all_gene2go;
print OUT  'GO_ID',"\t",'GO_term',"\t",'TYPE',"\t",'target_gene_in_this_GO',"\t",'all_target_gene_in_all_GO',"\t",'all_gene_in_this_GO',"\t",'all_gene_in_all_GO',"\t",'gene_list',"\t",'rich_factor',"\t",'Pvalue',"\t",'Qvalue',"\n";
print OUT1  'GO_ID',"\t",'GO_term',"\t",'TYPE',"\t",'target_gene_in_this_GO',"\t",'all_target_gene_in_all_GO',"\t",'all_gene_in_this_GO',"\t",'all_gene_in_all_GO',"\t",'gene_list',"\t",'rich_factor',"\t",'Pvalue',"\t",'Qvalue',"\n";

my  (%p_value,%last,%factor)=();
my $index=0;
my $count=0;
my  ($gene_list,$downs);
foreach  my $dg(keys %diff_go){    
     my  $p=Comparison::calculate_significance($diff_go{$dg}, $all_go{$dg},$num,$all);   
     $p_value{$dg}=$p;         
     if($diff_go{$dg}<2){
	$p_value{$dg}=1;
      }
     my $factor=($diff_go{$dg}/$all_go{$dg})/($num/$all);
      if($factor<1){
	  $p_value{$dg}='-';
      }
       if($diff_go{$dg}<4){
	$p_value{$dg}='-';
	$factor=1;
      }      
    $last{$dg}=$dg."\t".$info_go{$dg}."\t".$diff_go{$dg}."\t".$num."\t".$all_go{$dg}."\t".$all."\t".$diff_gene_list{$dg}."\t".($diff_go{$dg}/$all_go{$dg})/($num/$all)."\t".$p_value{$dg};
    $factor{$dg}=$factor;
}
my  $n=keys %p_value;
my $temp=-1;
foreach my $eg(sort {$p_value{$a} <=> $p_value{$b}} keys %p_value){
        if($p_value{$eg} eq '-'){
             my  $fdr='-';
          $last{$eg}.="\t".$fdr."\n"; 
             next;
        }
        $count++;
        if($p_value{$eg} != $temp){
        my $fdr =$p_value{$eg}*$n/$count;
	   if($fdr>1){
            $fdr=1;
            }	
           $last{$eg}.="\t".$fdr."\n";        
		$index=$count;
        }else{
            my $fdr =$p_value{$eg}*$n/$index;
	   if($fdr>1){
            $fdr=1;
            }	    
            $last{$eg}.="\t".$fdr."\n";         
	}
        $temp=$p_value{$eg};
        
}
foreach my $eg(sort {$factor{$b} <=> $factor{$a}} keys %factor){
	print OUT1  $last{$eg};
	if($p_value{$eg} eq '-'){
	   next;}
	print OUT  $last{$eg};	
}
close GO;
close OUT;
print  "Bar plot...................\n";
my $gn=$out_name.'_GO_enrichment';
system("Rscript GO_enrichment_lncRNA.R $out  $gn");
}
