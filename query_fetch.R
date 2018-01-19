# install rentrez, a package to retrieve information from the NCBI databases 
# (run only one)
# install.packages("rentrez")

library(rentrez)

# list available databases
entrez_dbs()

entrez_db_searchable("nuccore")

# retrieve records related to Mycobacterium tuberculosis H37Rv
mtu_h37rv <- entrez_search(db="nuccore", 
              term="Mycobacterium tuberculosis H37Rv[ORGN] AND complete genome[TITL]")
mtu_h37rv_summary <- entrez_summary(db = "nuccore", id = mtu_h37rv$ids)
mtu_h37rv_info <- do.call("rbind", 
                     lapply(mtu_h37rv_summary, 
                         function(x) cbind(x$sourcedb, x$gi, x$title, x$createdate)))
colnames(mtu_h37rv_info) <- c("DB", "gi", "title", "creation_date")
mtu_h37rv_info <- data.frame(mtu_h37rv_info)
mtu_h37rv_info
# DB        gi                                                  title creation_date
# 1 refseq 448814763      Mycobacterium tuberculosis H37Rv, complete genome    2001/09/07
# 2 refseq 749556344 Mycobacterium tuberculosis H37RvSiena, complete genome    2015/01/23
# 3   insd 749193065 Mycobacterium tuberculosis H37RvSiena, complete genome    2015/01/21
# 4 refseq 752689705      Mycobacterium tuberculosis H37Rv, complete genome    2015/02/04
# 5 refseq 561108321      Mycobacterium tuberculosis H37Rv, complete genome    2012/07/25
# 6   insd 690310687      Mycobacterium tuberculosis H37Rv, complete genome    2014/09/26
# 7   insd 444893469       Mycobacterium tuberculosis H37Rv complete genome    2002/07/18
# 8   insd 559794742      Mycobacterium tuberculosis H37Rv, complete genome    2012/07/12

# There are several genome sequencing projects for M. tuberculosis H37Rv, including
# the Siena variant. At this moment we are only interested in the first genome project,
# gi|448814763

mtu_h37Rv_gb <- entrez_fetch(db="nuccore", id=448814763, rettype="gbwithparts" )

  
