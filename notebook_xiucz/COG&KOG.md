## 简介
Clusters of Orthologous Groups of proteins(COG)，同源蛋白簇，构成每个COG的蛋白都是被假定为来自于一个祖先蛋白，并且因此或者是orthologs或者是paralogs。  
Orthologs是指来自于不同物种的由垂直家系（物种形成）进化而来的蛋白，并且典型的保留与原始蛋白有相同的功能。  
Paralogs是那些在一定物种中的来源于基因复制的蛋白，可能会进化出新的与原来有关的功能。

原核生物的一般称为COG数据库；真核生物的一般称为KOG数据库。

https://www.ncbi.nlm.nih.gov/COG/  
ftp://ftp.ncbi.nih.gov/pub/COG/  

**COG如何建立：**  
COG是通过把所有完整测序的基因组的编码蛋白一个一个的互相比较确定的。在考虑来自一个给定基因组的蛋白时，
这种比较将给出每个其他基因组的一个最相似的蛋白（因此需要用完整的基因组来定义COG。注1）这些基因的每一个都轮番的被考虑。
如果在这些蛋白（或子集）之间一个相互的最佳匹配关系被发现，那么那些相互的最佳匹配将形成一个COG（注2）。
这样，一个COG中的成员将与这个COG中的其他成员比起被比较的基因组中的其他蛋白更相像，尽管如果绝对相似性比较的。
最佳匹配原则的使用，没有了人为选择的统计切除的限制，这就兼顾了进化慢和进化快的蛋白。
然而，还有一个加的限制就是一个COG必须包含来自于3个种系发生上远的基因组的一个蛋白。

 

**COG注释作用：** 
1. 通过已知蛋白对未知序列进行功能注释；  
2. 通过查看指定的COG编号对应的protein数目，存在及缺失，从而能推导特定的代谢途径是否存在；  
3. 每个COG编号是一类蛋白，将query序列和比对上的COG编号的proteins进行多序列比对，能确定保守位点，分析其进化关系。

## 步骤
1. 建立COG库  
[myva](ftp://ftp.ncbi.nih.gov/pub/COG/COG/myva)文件，COG数据库的蛋白质序列，有192987条。将该序列文件使用使用
ncbi-blast-2.2.26+中的blastdb程序制作出前缀为cog的蛋白质数据库。
```
makeblastdb -in input_file -dbtype molecule_type -title database_title -parse_seqids -out database_name -logfile File_Name
```

2. 将基因序列进行COG注释  
将需要进行COG注释并分类的DNA序列或protein序列分别使用blastx或blastp比对到上一步骤建好的cog数据库中。得出xml的比对结果。
```
#PBS -N COG
#PBS -j oe
#PBS -l nodes=1:ppn=8
#PBS -r y
#PBS -q blast
/data/soft/blast/ncbi-blast-2.2.28+/bin/rpstblastn \
-query /data/genome/Prokaryotic/Streptococcus_suis_SC84/GCF_000026725.1_ASM2672v1_genomic.gene.fa \
-db /data/blast_db/KOG/cdd/Cog \
-out ${work_dir}/COG/Cog_out_last \
-evalue 1e-5 \
-outfmt "6 qseqid qlen sseqid slen evalue score length positive pident qstart qend sstart send stitle" \
-max_target_seqs 1
```

3. 整理结果
```
perl  ~/RNAseq/scripts/COG/get_COG_ANNOTATION.pl Cog_out_last
```

4. 绘图
```
perl ~/RNAseq/scripts/COG/diff_gene_COG_class.pl COG_ANNOTATION.xls
perl ~/RNAseq/scripts/COG/COG_enrichment.pl COG_ANNOTATION.xls
```
