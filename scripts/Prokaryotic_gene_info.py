import re, sys

gff_file = sys.argv[1]

ID2locustag_dict = {}
Parent2product_dict = {}
ID2gene_dict = {}
ID2oldlocustag_dict = {}

def NCBIgffParse(gff_file):
    with open(gff_file) as gfffile:
        for line in gfffile:
            if line.startswith("#"):continue
            else:
                cols = line.strip().split("\t")
                core_item = cols[8].split(";")
                if cols[2] == "gene":
                    ID = re.search('ID=(\w+);', cols[8]).group(1)
                    locus_tag = re.search(';locus_tag=(\w+)', cols[8]).group(1)
                    ID2locustag_dict[ID] = locus_tag
                    gene = (re.search(';gene=(\w+)', cols[8]).group(1) if ("gene=" in cols[8]) else "-")
                    ID2gene_dict[ID] = gene
                    old_locus_tag = ((re.search(';old_locus_tag=(\w+)', cols[8]).group(1)) if ("old_locus_tag=" in cols[8]) else "-")
                    ID2oldlocustag_dict[ID] = old_locus_tag
                if cols[2] == "CDS":
                    Parent = re.search('Parent=(\w+)', cols[8]).group(1)
                    product = re.search(';product=(.*?);', cols[8]).group(1)
                    Parent2product_dict[Parent] = product
                else:continue
    return(ID2locustag_dict, Parent2product_dict)

ID2locustag, Parent2product = NCBIgffParse(gff_file)

for rankey, ranvalue in Parent2product.items():
    tmp = ID2locustag.get(rankey, "-")
    gene_name = ID2gene_dict.get(rankey, "-")
    old_locus_tag = ID2oldlocustag_dict.get(rankey, "-")
    print(tmp + "\t" + gene_name + "\t" + ranvalue + "\t" + old_locus_tag)
