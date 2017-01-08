hk = readLines("./inst/config/TWPhrases.txt")
hkt = str_split(hk,"\t")
hkn = character(length(hkt))
for (ii in 1:length(hkt)){
    hkn[[ii]] = paste0(hkt[[ii]][[2]],"\t",hkt[[ii]][[1]])
}
writeLines(hkn,"./inst/config/TWPhrasesRev.txt")