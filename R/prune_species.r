################################################################################
#' Prune unwanted species / taxa from a phylogenetic object.
#' 
#' An S4 Generic method for removing (pruning) unwanted taxa from phylogenetic
#' objects, including phylo and phylo4 trees, as well as native phyloseq package
#' objects. This is particularly useful for pruning a phyloseq object that has
#' more than one component that describes species.
#' The \code{phylo} class version is adapted from \code{picante::prune.samples}.
#'
#' @param species (Required). A character vector of the species in object x that you want to
#' keep -- OR alternatively -- a logical vector where the kept species are TRUE, and length
#' is equal to the number of species in object x. If \code{species} is a named
#' logical, the species retained is based on those names. Make sure they are
#' compatible with the \code{species.names} of the object you are modifying (\code{x}). 
#'
#' @param x (Required). A phylogenetic object, including \code{phylo} and \code{phylo4} trees,
#' as well as all phyloseq classes that represent taxa / species. If the function
#' \code{\link{species.names}} returns a non-\code{NULL} value, then your object
#' can be pruned by this function.
#'
#' @return The class of the object returned by \code{prune_species} matches
#' the class of the argument, \code{x}.
#'
#' @name prune_species
#' @rdname prune_species-methods
#' @export
#' @examples #
#' ## testOTU <- otuTable(matrix(sample(1:50, 25, replace=TRUE), 5, 5), speciesAreRows=FALSE)
#' ## f1  <- filterfunSample(topk(2))
#' ## wh1 <- genefilterSample(testOTU, f1, A=2)
#' ## wh2 <- c(T, T, T, F, F)
#' ## prune_species(wh1, testOTU)
#' ## prune_species(wh2, testOTU)
#' ## 
#' ## taxtab1 <- taxTab(matrix("abc", 5, 5))
#' ## prune_species(wh1, taxtab1)
#' ## prune_species(wh2, taxtab1)
setGeneric("prune_species", function(species, x) standardGeneric("prune_species"))
################################################################################
#' @aliases prune_species,NULL,ANY-method
#' @rdname prune_species-methods
setMethod("prune_species", signature("NULL"), function(species, x){
	return(x)
})
################################################################################
#' @aliases prune_species,character,phylo-method
#' @rdname prune_species-methods
setMethod("prune_species", signature("character", "phylo"), function(species, x){
	trimTaxa <- setdiff(x$tip.label, species)
	if( length(trimTaxa) > 0 ){
		ape::drop.tip(x, trimTaxa)
	} else x
})
################################################################################
#' @aliases prune_species,character,phylo4-method
#' @rdname prune_species-methods
#' @import phylobase
setMethod("prune_species", signature("character", "phylo4"), function(species, x){
	trimTaxa <- setdiff(tipLabels(x), species)
	if( length(trimTaxa) > 0 ){
		## temporary hack; phylobase subset sometimes too slow or fails
		# subset(x, tips.exclude=trimTaxa)
		## convert to "phylo" tree, trim, then back to "phylo4".
		x <- ape::drop.tip(suppressWarnings(as(x, "phylo")), trimTaxa)
		as(x, "phylo4")
	} else x
})
################################################################################
#' @aliases prune_species,character,otuTable-method
#' @rdname prune_species-methods
setMethod("prune_species", signature("character", "otuTable"), function(species, x){
	species <- intersect( species, species.names(x) )
	if( speciesarerows(x) ){
		x[species, , drop=FALSE]
	} else {
		x[, species, drop=FALSE]
	}	
})
################################################################################
#' @aliases prune_species,character,sampleMap-method
#' @rdname prune_species-methods
setMethod("prune_species", signature("character", "sampleMap"), function(species, x){
	return(x)
})
################################################################################
#' @aliases prune_species,character,phyloseq-method
#' @rdname prune_species-methods
setMethod("prune_species", signature("character", "phyloseq"), 
		function(species, x){
	# Save time and return if species of x are same as species
	if( setequal(species, species.names(x)) ){
		return(x)
	} else {	
		# All phyloseq objects have an otuTable slot, no need to test.
		x@otuTable   <- prune_species(species, otuTable(x))
		
		# Test if slot is present. If so, perform the component prune.
		if( !is.null(access(x, "taxTab")) ){
			x@taxTab <- prune_species(species, taxTab(x))
		}
		if( !is.null(access(x, "tre")) ){
			x@tre    <- prune_species(species, tre(x))
		}
		return(x)
	}
})
################################################################################
#' @aliases prune_species,character,taxonomyTable-method
#' @rdname prune_species-methods
setMethod("prune_species", signature("character", "taxonomyTable"), 
		function(species, x){
	species <- intersect( species, species.names(x) )
	return( x[species, , drop=FALSE] )
})
################################################################################
#' @aliases prune_species,logical,ANY-method
#' @rdname prune_species-methods
setMethod("prune_species", signature("logical", "ANY"), function(species, x){
	# convert the logical argument to character and dispatch
	if( is.null(names(species)) ){
		species <- species.names(x)[species]
	} else {
		species <- names(species)[species]
	}
	prune_species(species, x)
})
################################################################################
