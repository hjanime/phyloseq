\name{filter_taxa}
\alias{filter_taxa}
\title{Filter taxa based on across-sample OTU abundance criteria}
\usage{
  filter_taxa(physeq, flist, prune=FALSE)
}
\arguments{
  \item{physeq}{(Required). A \code{\link{phyloseq-class}}
  object that you want to trim/filter.}

  \item{flist}{(Required). A function or list of functions
  that take a vector of abundance values and return a
  logical. Some canned useful function types are included
  in the \code{genefilter}-package.}

  \item{prune}{(Optional). A logical. Default \code{FALSE}.
  If \code{TRUE}, then the function returns the pruned
  \code{\link{phyloseq-class}} object, rather than the
  logical vector of taxa that passed the filter.}
}
\value{
  A logical vector equal to the number of taxa in
  \code{physeq}. This can be provided directly to
  \code{\link{prune_taxa}} as first argument.
  Alternatively, if \code{prune==TRUE}, the pruned
  \code{\link{phyloseq-class}} object is returned instead.
}
\description{
  This function is directly analogous to the
  \code{\link[genefilter]{genefilter}} function for
  microarray filtering, but is used for filtering OTUs from
  phyloseq objects. It applies an arbitrary set of
  functions --- as a function list, for instance, created
  by \code{\link[genefilter]{filterfun}} --- as
  across-sample criteria, one OTU at a time. It takes as
  input a phyloseq object, and returns a logical vector
  indicating whether or not each OTU passed the criteria.
  Alternatively, if the \code{"prune"} option is set to
  \code{FALSE}, it returns the already-trimmed version of
  the phyloseq object.
}
\examples{
data("enterotype")
require("genefilter")
flist    <- filterfun(kOverA(5, 2e-05))
ent.logi <- filter_taxa(enterotype, flist)
ent.trim <- filter_taxa(enterotype, flist, TRUE)
identical(ent.trim, prune_taxa(ent.logi, enterotype))
identical(sum(ent.logi), ntaxa(ent.trim))
filter_taxa(enterotype, flist, TRUE)
}
\seealso{
  \code{\link[genefilter]{filterfun}},
  \code{\link{genefilter_sample}},
  \code{\link{filterfun_sample}}
}

