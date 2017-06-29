#!/usr/bin/perl -w
use strict;
open  GTF ,  $ARGV[0];
open OUT  ,  ">$ARGV[0].bed";
my  (%gene,%loc,%chr,%type)=();
while(<GTF>){
    chomp;
  my  @ls=split "\t";
  if($ls[8]=~/gene_id "(\S+?)";/){
    my  $gene_name=$1 ;
  if(exists $gene{$gene_name}{$ls[2]}{$ls[3]}{$ls[4]}){

    next;

  }else{

    print  OUT  $ls[0],"\t",$ls[3]-1,"\t",$ls[4],"\t",$ls[2],"\t",$gene_name,"\t",$ls[1],"\n";
     $gene{$gene_name}{$ls[2]}{$ls[3]}{$ls[4]}=1;
     push @{$loc{$gene_name}{$ls[2]}},$ls[3];
      push @{$loc{$gene_name}{$ls[2]}},$ls[4];
       $chr{$gene_name}=$ls[0];
       $type{$gene_name}=$ls[1];
    }

  }

}
foreach my $gn(keys %gene){
     my @start=sort {$a <=> $b} @{$loc{$gn}{'exon'}};
     print OUT  $chr{$gn},"\t",$start[0]-1,"\t",$start[@start-1],"\t",'gene',"\t",$gn,"\t",$type{$gn},"\n";
}
