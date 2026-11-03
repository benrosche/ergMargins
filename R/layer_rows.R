#' Internal: rows of a multilayer dyad list that belong to a term's layer.
#'
#' In a multilayer ERGM (ergm.multi), ergmMPLE() returns one row per dyad and
#' layer. A term of a single layer, such as "L(support)~nodematch.x", only
#' enters the tie probabilities of that layer, so its marginal effect is
#' averaged over that layer's dyads. The layer of a row is the layer of its
#' tail node, from the ".LayerName" (or ".LayerID") vertex attribute.
#'
#' Returns NULL, meaning "use all rows", when the network is not multilayer,
#' when none of the terms is a layer term, when a term combines layers (for
#' example "L(support&opposition)~edges"), or when the terms belong to
#' different layers.
#'
#' @param network The model's network (model$network).
#' @param dyadlist The predictor matrix from ergmMPLE(output = "dyadlist"),
#'   including its "tail" column.
#' @param terms Character vector of the model terms involved.
#' @keywords internal
layer_rows <- function(network, dyadlist, terms) {
  if (!".LayerID" %in% network::list.vertex.attributes(network)) {
    return(NULL)
  }
  terms <- terms[grepl("^L\\(", terms)]
  if (length(terms) == 0) {
    return(NULL)
  }
  layers <- unique(sub("^L\\(([^)]*)\\)~.*$", "\\1", terms))
  if (length(layers) != 1 || grepl("[&|!(), ]", layers)) {
    return(NULL)
  }
  tails <- dyadlist[, "tail"]
  layer_name <- network::get.vertex.attribute(network, ".LayerName")
  layer_id <- network::get.vertex.attribute(network, ".LayerID")
  if (!is.null(layer_name) && layers %in% layer_name) {
    rows <- layer_name[tails] == layers
  } else if (layers %in% as.character(layer_id)) {
    rows <- as.character(layer_id[tails]) == layers
  } else {
    return(NULL)
  }
  if (!any(rows)) {
    return(NULL)
  }
  rows
}
