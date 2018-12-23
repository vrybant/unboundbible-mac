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
     "</f>":"<Rf>"]

private func replaceTags(list: inout [String]) {
    for i in 0...list.count-1 {
	  if let value = dictionary[list[i]] { list[i] = value }
    }
}

private func strongs(_ string: inout String) {
    let list = xmlToList(string: string)
    string = ""
    for item in list {
        if item.hasPrefix("<W") {
            let number = item.replace("<W","").replace(">","")
            string += "<S>" + number + "</S>"
        } else {
            string += item
        }
    }
}

private func extractFootnoteMarker(_ string: String) -> String {
    var result = ""
    if let range = string.range(of: "=") {
        result = String(string[range.lowerBound..<string.endIndex])
    }
    return result.replace(">","")
}

/* procedure FootnotesEx(var s: string);
begin
  Replace(s,'<RF ','<RF><');
  Replace(s,'<Rf>','~]<Rf>');
  ExtractMarkers(s);
  CutStr(s,'[~','~]');
end;

procedure Footnotes(var s: string);
begin
  Replace(s,'<RF>','<RF>*[~');
  Replace(s,'<Rf>','~]<Rf>');
   CutStr(s,'[~','~]');
end;
*/

private func footnotes(_ string: inout String) {
    string = string.replace("<RF>","<RF>*[~")
    string = string.replace("<Rf>","~]<Rf>" )
    string = string.cut(from: "[~", to: "~]")
}

func prepare(_ string: String, format: FileFormat, purge: Bool = true)-> String {
    var string = string

    if format == .unbound {
        if string.contains("<W"  ) { strongs(&string) }
        if string.contains("<RF>") { footnotes(&string) }
    }
    
//   replaceTags(list: &list)

    string = string.cut(from: "<TS>", to: "<Ts>")
    if purge { string = string.cut(from: "<RF", to:"<Rf>") }
    string = string.replace("</S><S>","</S> <S>") // strongs

    return string
}
