#' Converter
#'
#' create a converter. S2T means Simplified Chinese to Traditional Chinese. T2S means Traditional Chinese to Simplified Chinese.
#'
#' @examples
#' \dontrun{
#' cc = converter(S2T)
#' }
#'
#' @param type T2S S2T S2TW HK2S S2HK S2TWP T2HK T2S T2TW TW2S TW2SP
#' @export
converter <- function(type=ropencc::S2T) {
    ropenccpath <- find.package("ropencc")
    if(file.exists(type)){
        res = converter_create(type)
        class(res) = "cc_converter"
        return(res)
    } else{
        message("loading config: ", type)
        stop("no such config file.")
    }
}

#' Run Converter
#'
#' run converter
#'
#' @examples
#' \dontrun{
#' cc = converter()
#' cc["TEXT"]
#' }
#' @param worker opencc worker
#' @param text input text
#' @export
run_convert <- function(worker,text) {
    if(.Platform$OS.type=="windows"){
        text = enc2utf8(text)
    }
    res = convert(worker, text)
    if(.Platform$OS.type=="windows"){
        Encoding(res) = "UTF-8"
    }
    res
}

#' @rdname run_convert
#' @param ptr worker
#' @param code input text
#' @export
`[.cc_converter` <- function(ptr, code){
    return(run_convert(ptr, code))
}


#' @title convert_file
#'
#' @usage convert_file(input, output, type = ropencc::S2T, inputEncoding = 'UTF-8', ...)
#'
#' @param input input file name
#' @param output output file name
#' @param type one of T2S S2T S2TW HK2S S2HK S2TWP T2HK T2S T2TW TW2S TW2SP
#' @param inputEncoding  encoding for input
#' @param ... other parameter pass to readLines function
#' @export

convert_file = function(input,
                        output,
                        type = ropencc::S2T,
                        inputEncoding = 'UTF-8',
                        ...){
    if(!file.exists(input)){
        stop("no such file.")
    }
    if (file.exists(output)) {
        warning("Thers is a file in the output path.")
    }
    strings = readLines(input, encoding = inputEncoding, ...)
    outputStrings = converter(type)[strings]
    writeLines(outputStrings, con = output, useBytes = T)
    message("Finish writing!")
}