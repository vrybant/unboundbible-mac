//
//  prepare.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

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
    var r = "{~" + string + "~}"
    
    r = r.replace("\n", "") // ESWORD ?
    
    return r
}
