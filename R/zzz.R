##' @useDynLib ropencc
##' @import Rcpp
##' @importFrom utils file.edit unzip
NULL

#' The path of dictionary
#'
#' The path of dictionary, and it is used by translation.
#' @format  character
#' @export
S2T<-NULL

#' @rdname S2T
#' @export
S2TW<-NULL


#' @rdname S2T
#' @export
HK2S<-NULL

#' @rdname S2T
#' @export
S2HK<-NULL

#' @rdname S2T
#' @export
S2TWP<-NULL

#' @rdname S2T
#' @export
T2HK<-NULL

#' @rdname S2T
#' @export
T2S<-NULL

#' @rdname S2T
#' @export
T2TW<-NULL

#' @rdname S2T
#' @export
TW2S<-NULL

#' @rdname S2T
#' @export
TW2SP<-NULL

TIMESTAMP<-NULL

.onLoad <- function(libname, pkgname) {
#     if (.Platform$OS.type == "windows") {
#       Sys.setlocale( locale = "English")
#     }

    assign(x = "TIMESTAMP",  as.numeric(Sys.time()),asNamespace('ropencc'))

    assign(x = "S2T", file.path(find.package("ropencc"),"config","s2t.json"),asNamespace('ropencc'))
    assign(x = "HK2S", file.path(find.package("ropencc"),"config","hk2s.json"),asNamespace('ropencc'))
    assign(x = "S2HK", file.path(find.package("ropencc"),"config","s2hk.json"),asNamespace('ropencc'))
    assign(x = "S2TW",  file.path(find.package("ropencc"),"config","s2tw.json"),asNamespace('ropencc'))
    assign(x = "S2TWP",  file.path(find.package("ropencc"),"config","s2twp.json"),asNamespace('ropencc'))
    assign(x = "T2HK",  file.path(find.package("ropencc"),"config","t2hk.json"),asNamespace('ropencc'))
    assign(x = "T2S",  file.path(find.package("ropencc"),"config","t2s.json"),asNamespace('ropencc'))
    assign(x = "T2TW",  file.path(find.package("ropencc"),"config","t2tw.json"),asNamespace('ropencc'))
    assign(x = "TW2S",  file.path(find.package("ropencc"),"config","tw2s.json"),asNamespace('ropencc'))
    assign(x = "TW2SP",  file.path(find.package("ropencc"),"config","tw2sp.json"),asNamespace('ropencc'))

}
