use strict;
use Comparison;
open  ALL , $ARGV[0];
my (%path,%all_num,%des,%all_list,%factor);
while(<ALL>){
   chomp;
   s/"//g;
   next if /PATHWAY_ID/;
   my @ls=split "\t";
   $ls[1]=~s/ (-[^-]+)$//;
   $all_num{$ls[0]}=$ls[2];
   $des{$ls[0]}=$ls[1];
   my @gl=split ",",$ls[3];
   foreach my $g(@gl){
    $path{$ls[0]}{$g}=1;  
      $all_list{$g}=1;
      
   }
   
   
}
my $all_gene=keys %all_list;
my @diff_file=<*.txt>;
foreach my $file(@diff_file){
   my ($name1,$name2); 
    if($file=~/(\S+).txt/){
        $name1=$1;
       
    }
    my $out_name=$name1;
    my $out=$out_name."_KEGG_enrichment.xls";

     open OUT  , '>'.$name1.'_KEGG_enrichment.xls';
    print OUT  'pathway_ID',"\t",'PATHWAY_DES',"\t",'target_gene_in_this_pathway',"\t",'target_gene_in_all_pathway',"\t",'all_gene_in_this_pathway',"\t",'all_gene_in_all_pathway',"\t",'all_gene_list',"\t",'rich_factor',"\t",'Pvalue',"\t",'Qvalue',"\n";
  
    
   
    my %ens2geneid=();
    my %diff_list=();
    my  (%all,%p_value)=();
    my $all_diff=0;
    open DIFF,$file;
    my (%up_list,%down_list)=();
    while(<DIFF>){
        chomp;
    
        next if /^#/;
        
     my @par=split "\t";
     next if $par[0] eq 'Unigene_id';
     next unless $par[0];
     $ens2geneid{$par[0]}=1;
       if(exists $all_list{$par[0]}){
          $all_diff++;
          
          }
       $diff_list{$par[0]}=1;
       
       
       }
   
    foreach my $way(keys %path){
      my $diff_p=0;
      my $dl="";
      my $ensemble_up="";
       my $ensemble_down="";
      foreach my $dg(keys %diff_list){
         if(exists $path{$way}{$dg}){
            
            $dl.=$dg.',';
            $diff_p++;
         }
         
         
      }
      my ($ups,$downs)=0;
    if($diff_p){
         if($ensemble_up){
		    my @p=split /,/ , $ensemble_up;
            $ups=@p;			
		 
		 }else{
		   $ensemble_up='-';
		   $ups=0;
		 
		 }
         if ($ensemble_down){
		 my @p=split /,/ , $ensemble_down;
            $downs=@p;
		 }else{
		 
		 $ensemble_down='-' ;
		  $downs=0;
		 
		 }
      my  $p=Comparison::calculate_significance($diff_p,$all_diff,$all_num{$way},$all_gene);
       $p_value{$way}=$p;
        my $factor=($diff_p/$all_num{$way})/($all_diff/$all_gene);
      if($factor<1){
	  $p_value{$way}=1;
      }
         if($diff_p<2){
	     $p_value{$way}=1;
             $factor=1;
         }
      $all{$way}=$way."\t".$des{$way}."\t".$diff_p."\t".$all_diff."\t".$all_num{$way}."\t".$all_gene."\t".$dl."\t".($diff_p/$all_num{$way})/($all_diff/$all_gene)."\t".$p_value{$way};
      $factor{$way}=$factor;
      
      }  
      
      
    }
my  $n=keys %p_value;
my $temp=-1;
my $count=0;
my $index=0;
foreach my $eg(sort {$p_value{$a} <=> $p_value{$b}} keys %p_value){
      if($p_value{$eg} eq '-'){
        my  $fdr='-';
        $all{$eg}.="\t".$fdr."\n";
        next;
      }
      $count++;
      if($p_value{$eg} != $temp){
         
         my $fdr =$p_value{$eg}*$n/$count;
	   if($fdr>1){
            $fdr=1;
            }         
         $all{$eg}.="\t".$fdr."\n";        
         $index=$count;
      }else{
          my $fdr =$p_value{$eg}*$n/$index;
            if($fdr>1){
            $fdr=1;
            }
          $all{$eg}.="\t".$fdr."\n";      
      }
      $temp=$p_value{$eg};       
}
foreach my $eg(sort {$factor{$b} <=> $factor{$a}} keys %factor){
	print OUT  $all{$eg};	
}
  
close DIFF;
close OUT;
print  "Bar plot...................\n";
my $gn=$out_name.'_KEGG_enrichment';
system("Rscript KEGG_enrichment.R $out  $gn");

}

