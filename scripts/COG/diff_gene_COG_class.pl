#!/usr/bin/perl -w
use strict;
use File::Basename;


my @list=<*_differential.xls>;
foreach my $file(@list){
open DIFF, $file;
my ($name1,$name2);
if($file=~/(\S+)_differential\.xls/){
        $name1=$1;
        
    }
my $out_name=$name1;
my $out=$out_name."_COG_class.xls";

open  OUT , ">$out";
my (%diff_COG,%info_COG,%gene2COG,%gene,%diff_gene_list)=();

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
    
    
    if(exists $gene{$ls[0]})
    {
        $gene2COG{$ls[0]}=1;
        $diff_COG{$ls[1]}++;
		
        $diff_gene_list{$ls[1]}.=$ls[0].',';        
    }   
    $info_COG{$ls[1]}=$ls[1].':'.$ls[2];
}
     
print OUT  'COG_type',"\t",'descript',"\t",'diff_gene_in_this_COG',"\t",'gene_list',"\n";

foreach  my $dg(keys %diff_COG){   			 
        print OUT  $dg."\t".$info_COG{$dg}."\t".$diff_COG{$dg}."\t".$diff_gene_list{$dg}."\n";
}

close COG;
close OUT;
print  "Bar plot...................\n";
my $gn=$out_name.'_COG_class';
system("Rscript COG_class.R $out  $gn");
}