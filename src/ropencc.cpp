#include <Rcpp.h>
using namespace Rcpp;
#include <ropencc.h>

#include "Config.hpp"
#include "Converter.hpp"
#include "UTF8Util.hpp"
#include "PhraseExtract.hpp"
#include "DartsDict.hpp"
#include "TextDict.hpp"
#include "SerializableDict.hpp"
using namespace opencc;

// Config config;
// ConverterPtr converter;

// [[Rcpp::export]]
XPtr<SimpleConverter> converter_create(CharacterVector file_){
    string configFileName = as<string>(file_[0]);
    return XPtr<SimpleConverter>(new SimpleConverter(configFileName));
}

using opencc::Exception;
using opencc::UTF8StringSlice;
using opencc::PhraseExtract;

// [[Rcpp::export]]
XPtr<PhraseExtract> extract_create(){

    XPtr<PhraseExtract> res = XPtr<PhraseExtract>(new PhraseExtract());
    res->SetWordMaxLength(2);
    res->SetPrefixSetLength(1);
    res->SetSuffixSetLength(1);

    return res;
}

// [[Rcpp::export]]
SEXP extract_set(XPtr<PhraseExtract> ptr,int WordMaxLength,int PrefixSetLength,int SuffixSetLength){
    ptr->SetWordMaxLength(WordMaxLength);
    ptr->SetPrefixSetLength(PrefixSetLength);
    ptr->SetSuffixSetLength(SuffixSetLength);

    return wrap(ptr);
}

// [[Rcpp::export]]
List extract(XPtr<PhraseExtract> extractor,CharacterVector input_){

    CharacterVector::iterator begin=input_.begin();
    CharacterVector::iterator end = input_.end();

    List res;

    for(CharacterVector::iterator it=begin;it!=end;it++){
        List res_inner;
        extractor->Reset();
        extractor->Extract(as<string>(*it));
        for (const auto& word : extractor->Words()) {

            const PhraseExtract::Signals& signals = extractor->Signal(word);

            const double entropy = signals.prefixEntropy + signals.suffixEntropy;

            const double logProbablity = extractor->LogProbability(word);
            res_inner.push_back(List::create( _["word"]= word.ToString(),
                                        _["signals.frequency"]= wrap(signals.frequency),
                                        _["logProbablity"]= wrap(logProbablity),
                                        _["signals.cohesion"]= wrap(signals.cohesion),
                                        _["entropy"]= wrap(entropy),
                                        _["signals.prefixEntropy"]= wrap(signals.prefixEntropy),
                                        _["signals.suffixEntropy"]= wrap(signals.suffixEntropy)
                                       )
                              );
        }
        res.push_back(res_inner);

    }
    return res;
}

// [[Rcpp::export]]
CharacterVector convert(XPtr<SimpleConverter> ptr, CharacterVector input_){

    CharacterVector::iterator begin=input_.begin();
    CharacterVector::iterator end = input_.end();

    vector<string> res=vector<string>();
    res.reserve(input_.size());

    for(CharacterVector::iterator it=begin;it!=end;it++){
        res.push_back(ptr->Convert(as<string>(*it)));
    }

    return wrap(res);
}

DictPtr LoadDictionary(const string& format, const string& inputFileName) {
    if (format == "text") {
        return SerializableDict::NewFromFile<TextDict>(inputFileName);
    } else if (format == "ocd") {
        return SerializableDict::NewFromFile<DartsDict>(inputFileName);
    } else {
        stop( "Unknown dictionary format: %s\n", format.c_str());
    }
    return nullptr;
}

SerializableDictPtr ConvertDictionary(const string& format,
                                      const DictPtr dict) {
    if (format == "text") {
        return TextDict::NewFromDict(*dict.get());
    } else if (format == "ocd") {
        return DartsDict::NewFromDict(*dict.get());
    } else {
        stop( "Unknown dictionary format: %s\n", format.c_str());
    }
    return nullptr;
}

// [[Rcpp::export]]
SEXP convert_dict(CharacterVector input_,CharacterVector output_,
                             CharacterVector from, CharacterVector to){
    //DictPtr dictFrom = ;
    SerializableDictPtr dictTo = ConvertDictionary(as<string>(to[0]), LoadDictionary(as<string>(from[0]), as<string>(input_[0])));
    dictTo->SerializeToFile(as<string>(output_));
    return wrap(output_);
}
// const string& converted = converter->Convert(line);
// converter = config.NewFromFile(configFileName);