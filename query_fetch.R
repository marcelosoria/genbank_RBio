# install rentrez, a package to retrieve information from the NCBI databases 
# (run only once to install)
# install.packages("rentrez")

library(rentrez)

# list available databases
entrez_dbs()

entrez_db_searchable("nuccore")

# Retrieve records related to complete genomes of 
# Mycobacterium tuberculosis H37Rv
ncbi_query <- "Mycobacterium tuberculosis H37Rv[ORGN] AND complete genome[TITL]"
mtu_h37rv <- entrez_search(db= "nuccore", term = ncbi_query)
mtu_h37rv_summary <- entrez_summary(db = "nuccore", id = mtu_h37rv$ids)

# mtu_h37rv_summary is a list containing the information available for
# every nuccore that satisfied the query
names(mtu_h37rv_summary[[1]])

# Prepare a dataframe with the information needed to decide the genome
# to be downloaded
mtu_h37rv_info <- do.call("rbind", 
                     lapply(mtu_h37rv_summary, 
                         function(x) cbind(x$sourcedb, x$gi, x$oslt$value, x$title, x$createdate)))
colnames(mtu_h37rv_info) <- c("DB", "gi", "oslt", "title", "creation_date")
mtu_h37rv_info <- data.frame(mtu_h37rv_info)
mtu_h37rv_info
#       DB        gi          oslt
# 1 refseq 448814763   NC_000962.3
# 2 refseq 749556344 NZ_CP007027.1
# 3   insd 749193065    CP007027.1
# 4 refseq 752689705 NZ_CP009480.1
# 5 refseq 561108321   NC_018143.2
# 6   insd 690310687    CP009480.1
# 7   insd 444893469    AL123456.3
# 8   insd 559794742    CP003248.2
# 
#                                                    title creation_date
# 1      Mycobacterium tuberculosis H37Rv, complete genome    2001/09/07
# 2 Mycobacterium tuberculosis H37RvSiena, complete genome    2015/01/23
# 3 Mycobacterium tuberculosis H37RvSiena, complete genome    2015/01/21
# 4      Mycobacterium tuberculosis H37Rv, complete genome    2015/02/04
# 5      Mycobacterium tuberculosis H37Rv, complete genome    2012/07/25
# 6      Mycobacterium tuberculosis H37Rv, complete genome    2014/09/26
# 7       Mycobacterium tuberculosis H37Rv complete genome    2002/07/18
# 8      Mycobacterium tuberculosis H37Rv, complete genome    2012/07/12

# There are several genome sequencing projects for M. tuberculosis H37Rv, including
# the Siena variant. At this moment we are only interested in the first genome project,
# gi|448814763, gbk|NC_000962

# Download the feature table, the nucleotide and aminoacid sequences of the CDS, or the 
# complete genome as a single DNA molecule
# feature table
mtu_h37Rv_ft <- entrez_fetch(db="nuccore", id="NC_000962", rettype="ft" )
writeLines(mtu_h37Rv_ft, "NC_000962.ft")
# CDS - nucleotida
mtu_h37Rv_cds_nucl <- entrez_fetch(db="nuccore", id=NC_000962, rettype="fasta_cds_na")
writeLines(mtu_h37Rv_cds_nucl, "NC_000962.fna")
# CDS - aminoacid
mtu_h37Rv_cds_aa <- entrez_fetch(db="nuccore", id="NC_000962", rettype="fasta_cds_aa")
writeLines(mtu_h37Rv_cds_aa, "NC_000962.faa")
# complete nucleotide sequence
mtu_h37Rv_fasta <- entrez_fetch(db="nuccore", id="NC_000962", rettype="fasta")
writeLines(mtu_h37Rv_fasta, "NC_000962.fasta")

# Graba en XML
mtu_h37Rv_gb <- entrez_fetch(db = "nuccore", id = "NC_000962", 
                             rettype = "gbwithparts", 
                             retmode = "text")
writeLines(mtu_h37Rv_gb, "NC_000962.gb")


# The following part is not working yet
# source("https://bioconductor.org/biocLite.R")
# biocLite("genbankr")
library(genbankr)
acc_NC_000962 <- GBAccession("NC_000962.3")
gbr_NC_000962 <- readGenBank(acc_NC_000962, partial=TRUE)

gba <- GBAccession("U49845.1")
gba
readGenBank(gba)

readGenBank("giNC_000962.gb", partial=TRUE)
gb_examp <- readGenBank(system.file("sample.gbk", package="genbankr"))

