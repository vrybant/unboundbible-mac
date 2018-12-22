//
//  prepare.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

private let dictionary = [
      "<J>":"<FR>",
     "</J>":"<Fr>",
      "<t>":"<FO>", // quote
     "</t>":"<Fo>",
      "<h>":"<TS>", // title
     "</h>":"<Ts>",
      "<f>":"<RF>", // footnote
     "</f>":"<Rf>",
      "<I>":"<FI>",
     "</I>":"<Fi>",
      "<i>":"<FI>",
     "</i>":"<Fi>",
     "<em>":"<FI>",
    "</em>":"<Fi>"]

private func replaceTags(list: inout [String]) {
    for i in 0...list.count-1 {
	  if let value = dictionary[list[i]] { list[i] = value }
    }
}

private func strongs(_ list: inout [String]) {
    for i in 0...list.count-1 {
        if list[i].hasPrefix("<W") {
            let number = list[i].replace("<W","").replace(">","")
            list[i] = "<S>" + number + "</S>"
        }
    }
}

/*
function ExtractFootnoteMarker(s: string): string;
var x1, x2 : integer;
begin
  Result := s;
  x1 := Pos('=',s); if x1 = 0 then Exit;
  x2 := Pos('>',s); if x2 = 0 then Exit;
  Result := Copy(s,x1+1,x2-x1-1);
end; */

private func extractFootnoteMarker(_ string: String) -> String {
    var result = ""
    if let range = string.range(of: "=") {
        result = String(string[range.lowerBound..<string.endIndex])
    }
    return result.replace(">","")
}

private func footnotes(_ list: inout [String]) {
    var marker = ""
    var l = false
    for i in 0...list.count-1 {
        if list[i] == "<RF>" {
            marker = "@"
            l = true
            continue
        }
        if list[i].hasPrefix("<RF ") {
            marker = extractFootnoteMarker(list[i])
            list[i] = "<RF>"
            l = true
            continue
        }
        if l && list[i] == "<Rf>" {
            l = false
            continue
        }
        if marker != "" {
            list[i] = marker
            marker = ""
            continue
        }
        if l {
            list[i] = ""
        }
    }
}

func prepare(_ string: String, format: FileFormat, purge: Bool = true)-> String {
    var list = xmlToList(string: string)
    
    if format == .unbound {
        if string.contains("<W" ) { strongs(&list) }   // if in win too
        if string.contains("<RF") { footnotes(&list) }
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
