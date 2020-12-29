## Run estimate_R with pandas series as input and output a dataframe
#' @post /estimate_R

function(req) {
  # Import libraries
  require(EpiEstim)
  require(jsonlite)
  
  # Post body
  body <- jsonlite::fromJSON(req$postBody)
  x <- body$var
  
  # Run function
  res_parametric_si <- EpiEstim::estimate_R(x,
                                            method = "parametric_si",
                                            config = EpiEstim::make_config(list(
                                              mean_si = 5.12,
                                              std_si = 1.86)))
  x <- as.data.frame(res_parametric_si$R)
  x <- jsonlite::toJSON(x, auto_unbox = TRUE)
  return(x)
}