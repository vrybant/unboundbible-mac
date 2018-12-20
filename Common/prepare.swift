//
//  prepare.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

private func replaceTag(_ string: inout String) {
    var r = string

    switch string {
        case   "<J>" : r = "<FR>"
        case  "</J>" : r = "<Fr>"
        case   "<t>" : r = "<FO>" // quote
        case  "</t>" : r = "<Fo>"
        case   "<h>" : r = "<TS>" // title
        case  "</h>" : r = "<Ts>"
        case   "<f>" : r = "<RF>" // footnote
        case  "</f>" : r = "<Rf>"
        default : break
    }
    switch string.lowercased() {
        case   "<i>" : r = "<FI>"
        case  "</i>" : r = "<Fi>"
        case  "<em>" : r = "<FI>"
        case "</em>" : r = "<Fi>"
        case "<pb/>" : r = ""     // unused tags
        case "<br/>" : r = ""
        default : break
    }
    string = r
}

private func replaceTags(list: inout [String]) {
    for i in 0...list.count-1 {
        replaceTag(&list[i])
    }
}
 
 /*
function Prepare(s: string; format: TFileFormat; purge: boolean = true): string;
var
  List : TStringArray;
begin
  List := XmlToList(s);

  if format = unbound then
    begin
      Strongs(List);
      Footnotes(List);
    end;

  ReplaceTags(List);
  PurgeTag(List,'<TS>','<Ts>');
  if purge then PurgeTag(List, '<RF','<Rf>');

  Result := Trim(ListToString(List));
  Replace(Result,'</S><S>','</S> <S>');
end;
*/

func prepare(_ string: String, format: FileFormat, purge: Bool = true)-> String {
    var list = xmlToList(string: string)
    
    if format == .unbound {
//        Strongs(List)
//        Footnotes(List)
    }
    
    replaceTags(list: &list)
//  PurgeTag(List,'<TS>','<Ts>');
//  if purge then PurgeTag(List, '<RF','<Rf>');
    
    var result = listToXml(list: list).trimmed
    result = result.replace("</S><S>","</S> <S>") // strongs
//                 .replace(" <f>","<f>")         // footnotes
//                 .replace("\n", "")             // ESWORD ?
    return result
}
