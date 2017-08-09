## 概念
#### KEGG三大数据库：  
基因数据库;  
化学分子物质数据库;  
以及基于基因和化学分子物质相互关系而建立起来的代谢路径数据库；

KO（KEGG Orthology），它是蛋白质（酶）的一个分类体系，序列高度相似，并且在同一条通路上有相似功能的蛋白质被归为一组，
然后打上KO（或K标签，KEGG orthology (ko)代表的是某个代谢途径，k代表的是某个酶，c代表的是某个化合物，M代表的是某个模块，
后面都会跟着编号。图中的正方形代表酶，圆形代表代谢物，5.4.4.4代表的是EC编号。而KAAS就是基于这么个数据库的一个快速检索的工具。

The method is based on sequence similarities,bi-directional best hit information and some heuristics, 
and has achieved a high degree of accuracy when compared with the manually curated KEGG GENES database.

对于酶来说，40-70%的序列相似性对于功能的预测有90%的准确性（Tian,W）。直系同源基于是来自于相同的祖先的基因分化，
保存在不同的物种中的功能基因。在实际操作中，他们能够通过BBH（bi-directional best hit）来推测出来。因此，对在许多物
种中的直系同源基因的鉴定是对新测序的基因功能预测的最便捷的途径。而KEGG 数据库就是通过KEGG Orthology (KO)系统来跨物种注释的一种机制。     
     
## KAAS
网站：http://www.genome.jp/tools/kaas/

![kaas_procedure](http://oqed7z48g.bkt.clouddn.com/20170809kaas_procedure.jpg)

**BHR(Bi-directional hit rate)**:    
    把要注释的geneome作为 query，和KEGG数据库中的reference进行blast比对，输出的结果（E>10）称为 homolog。
同时把 reference作为query，把geneome作为refernce，进行blast比对。按照下面的条件对每个 homolog 进行过滤，
Blast bits score > 60，bi-directional hit rate (BHR)>0.95。Blast Bits Score 是在 Blast raw score 换算过来的。

## Reference_Info
http://www.cnblogs.com/nkwy2012/p/6232239.html  
