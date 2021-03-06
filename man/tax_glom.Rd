\name{tax_glom}
\alias{tax_glom}
\title{Agglomerate taxa of the same type.}
\usage{
  tax_glom(physeq, taxrank=rank_names(physeq)[1],
  NArm=TRUE, bad_empty=c(NA, "", " ", "\t"))
}
\arguments{
  \item{physeq}{(Required). \code{\link{phyloseq-class}} or
  \code{\link{otu_table}}.}

  \item{taxrank}{A character string specifying the
  taxonomic level that you want to agglomerate over. Should
  be among the results of \code{rank_names(physeq)}. The
  default value is \code{rank_names(physeq)[1]}, which may
  agglomerate too broadly for a given experiment. You are
  strongly encouraged to try different values for this
  argument.}

  \item{NArm}{(Optional). Logical, length equal to one.
  Default is \code{TRUE}. CAUTION. The decision to prune
  (or not) taxa for which you lack categorical data could
  have a large effect on downstream analysis. You may want
  to re-compute your analysis under both conditions, or at
  least think carefully about what the effect might be and
  the reasons explaining the absence of information for
  certain taxa. In the case of taxonomy, it is often a
  result of imprecision in taxonomic designation based on
  short phylogenetic sequences and a patchy system of
  nomenclature. If this seems to be an issue for your
  analysis, think about also trying the
  nomenclature-agnostic \code{\link{tip_glom}} method if
  you have a phylogenetic tree available.}

  \item{bad_empty}{(Optional). Character vector. Default:
  \code{c(NA, "", " ", "\t")}. Defines the bad/empty values
  that should be ignored and/or considered unknown. They
  will be removed from the internal agglomeration vector
  derived from the argument to \code{tax}, and therefore
  agglomeration will not combine taxa according to the
  presence of these values in \code{tax}. Furthermore, the
  corresponding taxa can be optionally pruned from the
  output if \code{NArm} is set to \code{TRUE}.}
}
\value{
  A taxonomically-agglomerated, optionally-pruned, object
  with class matching the class of \code{physeq}.
}
\description{
  This method merges species that have the same taxonomy at
  a certain taxaonomic rank. Its approach is analogous to
  \code{\link{tip_glom}}, but uses categorical data instead
  of a tree. In principal, other categorical data known for
  all taxa could also be used in place of taxonomy, but for
  the moment, this must be stored in the
  \code{taxonomyTable} of the data. Also, columns/ranks to
  the right of the rank chosen to use for agglomeration
  will be replaced with \code{NA}, because they should be
  meaningless following agglomeration.
}
\examples{
# data(GlobalPatterns)
# ## print the available taxonomic ranks
# colnames(tax_table(GlobalPatterns))
# ## agglomerate at the Family taxonomic rank
# (x1 <- tax_glom(GlobalPatterns, taxrank="Family") )
# ## How many taxa before/after agglomeration?
# ntaxa(GlobalPatterns); ntaxa(x1)
# ## Look at enterotype dataset...
# data(enterotype)
# ## print the available taxonomic ranks. Shows only 1 rank available, not useful for tax_glom
# colnames(tax_table(enterotype))
}
\seealso{
  \code{\link{tip_glom}}

  \code{\link{prune_taxa}}

  \code{\link{merge_taxa}}
}

