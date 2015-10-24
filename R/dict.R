#' Dict Convertion
#'
#' Create dict from text file or create text file from ocd file.
#'
#' @param input input file
#' @param output output file
#' @param from_format from text or ocd
#' @param to_format to text or ocd
#' @export
make_dict <- function(input=NULL,output=NULL,from_format="text",to_format="ocd"){
    if(!file.exists(input)){
        stop("no such file.")
    }
    if(file.exists(output)){
        warning("Thers is a file in the output path.")
    }
    stopifnot(from_format %in% c("text","ocd") && to_format %in%  c("text","ocd") )
    convert_dict(input,output,from_format,to_format)
    return(output)
}
