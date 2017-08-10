#!/usr/bin/perl -w
my %class;
open (AA,"<Class.txt");
while(<AA>)
{
    chomp;
	@tmp=split(/\t/,$_);
	$class{$tmp[1]}=$tmp[0];

}
close AA;
my $input = shift;
open(IN,$input);
#my $out = shift;
open(OUT,">COG_ANNOTATION.xls");
my %hash;
 print OUT join("\t",'gene_id','COG_type','description',"\n");
while(<IN>) {
     chomp;
     my @infos = split(/\t/,$_);
     if(/\[(.*?)\]\./){
         my $name=$1;
	 my $aa=$1;
         foreach my $m(keys %class){
	     if($aa=~/$m/){
		if(!exists $hash{$infos[0]}{$class{$m}}){
	              print OUT join("\t",$infos[0],$class{$m},$m,"\n");
	         }
		 $hash{$infos[0]}{$class{$m}}=1;
		
            }
        }   
    }
}
close IN;
close OUT;

