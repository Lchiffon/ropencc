# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'



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
    if(!file.exists(file.path(ropenccpath,"config","S2T.json"))){
        try(unzip(file.path(ropenccpath,"config","config.zip"),exdir  = file.path( ropenccpath,"config") ) )
    }
    if(file.exists(type)){
        res = converter_create(type)
        class(res) = "cc_converter"
        return(res)
    } else{
        stop("no such file.")
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
    res = convert(worker,text)
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