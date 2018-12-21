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
            let number = list[i].replace("<W", "").replace(">", "")
            list[i] = "<S>" + number + "</S>"
        }
    }
}

func prepare(_ string: String, format: FileFormat, purge: Bool = true)-> String {
    var list = xmlToList(string: string)
    
    if format == .unbound {
        strongs(&list)
//      footnotes(&list)
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
