## 概念
### KEGG数据库：  


KEGG Orthology 简称KO, 对于每个功能已知的基因，会把和其同源的基因所有基因都归为一类，就是每一个KO, 并赋予一个K number（eg：K00161）, 用该基因的功能作为这个KO的功能；



### sites
http://www.genome.jp/kegg/catalog/org_list.html


## Introduce
![](../pictures/kegg3.png)
红框内的, 是KEGG分层数据库，包括对所有基因的功能注释和信号通路注释,这种分析有点类似GO分析，就是按照不同的功能以及信号通路进行分类，然后打上KO（KEGG Ontology）的标签。
蓝框中的，是KEGG的蛋白质或者酶的一个分类体系，他们把序列高度相似，并且在同一条通路上有相似功能的蛋白质被归为一组，然后打上KO（KEGG Orthologs）标签。
所以在KEGG上这两种KO标记其实是不一样的,
```
ko00001 ==> KEGG Ontology(本体论分层分类)
K04451 ==> KEGG Orthologs(KEGG同源物)
```
**k vs. ko**
k   ==> k number
ko ==> pathway map:蛋白质（酶）的一个分类体系，序列高度相似，并且在同一条通路上有相似功能的蛋白质被归为一组。
![](../pictures/kegg4.png)

**reference pathway vs. species-specific pathway**
+ 参考代谢通路图, reference pathway，是根据已有的知识绘制的概括的、详尽的具有一般参考意义的代谢图，这种图上就不会有绿色的小框，而都是无色的，所有的框都可以点击查看更详细的信息。reference pathway 在KEGG中的名字是以map 开头的;
+ 属于特定物种的代谢图, species-specific pathway，会用绿色来标出这个物种特有的基因或酶，只有这些绿色的框点击以后才会给出更详细的信息。

## KGML (KEGG Markup Language)
http://www.genome.jp/kegg/xml/
+ ko - reference pathway map linked to KO entries (K numbers)
+ rn - reference pathway map linked to REACTION entries (R numbers)
+ ec - reference pathway map linked to ENZYME entries (EC numbers)
+ org (three- or four-letter organism code) - organism-specific pathway map linked to GENES entries (gene IDs)

#### Ref_Info
http://blog.sciencenet.cn/blog-3307279-1057291.html

## KAAS
网站：http://www.genome.jp/tools/kaas/

![kaas_procedure](http://oqed7z48g.bkt.clouddn.com/20170809kaas_procedure.jpg)

ko代表的是某个代谢途径，k代表的是某个酶，c代表的是某个化合物，M代表的是某个模块，
后面都会跟着编号。图中的正方形代表酶，圆形代表代谢物，5.4.4.4代表的是EC编号。而KAAS就是基于这么个数据库的一个快速检索的工具。

The method is based on sequence similarities,bi-directional best hit information and some heuristics, 
and has achieved a high degree of accuracy when compared with the manually curated KEGG GENES database.

对于酶来说，40-70%的序列相似性对于功能的预测有90%的准确性（Tian,W）。直系同源基于是来自于相同的祖先的基因分化，
保存在不同的物种中的功能基因。在实际操作中，他们能够通过BBH（bi-directional best hit）来推测出来。因此，对在许多物
种中的直系同源基因的鉴定是对新测序的基因功能预测的最便捷的途径。而KEGG 数据库就是通过KEGG Orthology (KO)系统来跨物种注释的一种机制。 

**BHR(Bi-directional hit rate)**:    
    把要注释的geneome作为 query，和KEGG数据库中的reference进行blast比对，输出的结果（E>10）称为 homolog。
同时把 reference作为query，把geneome作为refernce，进行blast比对。按照下面的条件对每个 homolog 进行过滤，
Blast bits score > 60，bi-directional hit rate (BHR)>0.95。Blast Bits Score 是在 Blast raw score 换算过来的。

## 
http://www.genome.jp/kegg/tool/map_pathway2.html
## KOBAS

## R packages
http://bioconductor.org/packages/release/bioc/html/KEGGREST.html
```r
library(KEGGREST)
org <- keggList("organism")
```

## 6.KEGG api
### 6.1
KEGG 官网提供了API, 可以方便的访问KEGG 数据库中的内容，链接如下：
http://www.kegg.jp/kegg/rest/keggapi.html
```
http://rest.kegg.jp/<operation>/<argument>[/<argument2[/<argument3> ...]] <operation> = info | list | find | get | conv | link | ddi
```

例如， http://rest.kegg.jp/info/pathway
```
pathway          KEGG Pathway Database
path             Release 84.0+/12-27, Dec 17
                 Kanehisa Laboratories
                 552,726 entries

linked db        module
                 ko
                 genome
                 <org>
                 compound
                 glycan
                 reaction
                 rclass
                 enzyme
                 network
                 disease
                 drug
                 pubmed
```

利用API可以得到某一个基因参与的pathway 信息， 以human 为例；

1) 第一步，获取每条pathway具体的描述信息
对应的API为 ： http://rest.kegg.jp/list/pathway/hsa
内容如下：
```
path:hsa00010   Glycolysis / Gluconeogenesis - Homo sapiens (human)
path:hsa00020   Citrate cycle (TCA cycle) - Homo sapiens (human)
path:hsa00030   Pentose phosphate pathway - Homo sapiens (human)
path:hsa00040   Pentose and glucuronate interconversions - Homo sapiens (human)
path:hsa00051   Fructose and mannose metabolism - Homo sapiens (human)
```
可以看到，返回的内容一共两列，第一列为物种对应的pathway, 第二列为该pathway 对应的描述信息；

2)第二步， 获取物种对应的基因信息
对应的API 为：http://rest.kegg.jp/list/hsa
内容如下：
```
hsa:100287010   uncharacterized LOC100287010
hsa:100288846   uncharacterized LOC100288846
hsa:222029  DKFZp434L192; uncharacterized protein DKFZp434L192
hsa:146512  uncharacterized protein FLJ30679
hsa:100128288   uncharacterized LOC100128288
hsa:200058  uncharacterized protein FLJ23867
```
第一列为基因在KEGG数据库中的ID, 第二列为该基因的具体信息，其中RefSeq 字段之后的内容为该基因的名字，比如 hsa:222029 对应的gene symbol 为DKFzp434L92

如果这个基因在Refseq 之后的内容有逗号分隔的多个内容，取第一个作为其gene symbol
```
hsa:390660  ADAMTS7P1, ADAMTS7P2; ADAMTS7 pseudogene 1
```
以hsa:390660为例，对应的gene symbol 为 ADAMTS7P1
通过以上方法获得的gene symbol 和NCBI的GENE 数据库中的基因名是一致的

3） 第三步， 获取基因和pathway 之间的对应的关系
对应的API为：http://rest.kegg.jp/link/pathway/hsa
内容如下：
```
hsa:10327   path:hsa00010
hsa:124 path:hsa00010
hsa:125 path:hsa00010
hsa:126 path:hsa00010
```
可以看出，第一列为KEGG数据库中的ID, 第二列为该基因参与的pathway的ID;

比如我想得到基因所在的通路，比如NCBI基因10458，物种是人，那么我们就可以选择operation中的link，将url调整为：
```
http://rest.kegg.jp/link/pathway/hsa:10458
```

operation是get，dbentries就是ID号，查找ID为K00001的，那么api的URL为：
```
http://rest.kegg.jp/get/K00001
```

### 6.2.KEGGREST
R  http://www.bioconductor.org/packages/release/bioc/html/KEGGREST.html
python https://github.com/EnricoGiampieri/keggrest

#### Ref_Info
http://www.cnblogs.com/nkwy2012/p/6232239.html   
http://www.cnblogs.com/xudongliang/p/6845818.html  
http://www.jianshu.com/p/a6cb2dfa7cfb  