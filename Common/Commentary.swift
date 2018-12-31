//
//  Commentary.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

class Commentary: Module {
    private var z = CommentaryAlias()
    
    override init?(atPath: String) {
        super.init(atPath: atPath)
        if format == .mybible { z = mybibleCommentaryAlias }
        if connected && !database!.tableExists(z.commentary) { return nil }
        
        if connected {
            print("Commentary - \(atPath)")
        }
    }
}

var commentaries = Commentaries()

/*//=================================================================================================
//                                         TCommentaries
//=================================================================================================

function Comparison(const Item1: TCommentary; const Item2: TCommentary): integer;
var
  s1 : string = '';
  s2 : string = '';
begin
  if Orthodox(GetDefaultLanguage) then
    begin
      if Orthodox(Item1.language) then s1 := ' ';
      if Orthodox(Item2.language) then s2 := ' ';
    end;

  Result := CompareText(s1 + Item1.Name, s2 + Item2.Name);
end;

function TCommentaries.GetFootnote(module: string; Verse: TVerse; marker: string): string;
var
  name : string;
  i : integer;
begin
  Result := '';
  if self.Count = 0 then Exit;
  if marker = '❉' then marker := '*';
  name := ExtractOnlyName(module);

  for i:=0 to self.Count-1 do
    begin
      if not self[i].footnotes then Continue;
      if not Prefix(name,self[i].filename) then Continue;
      Result := self[i].GetFootnote(Verse, marker);
    end;
end;
*/

/*constructor TCommentaries.Create;
begin
  inherited;
  Load(GetUserDir + AppName);
  {$ifdef windows} if Self.Count = 0 then {$endif} Load(SharePath + 'bibles');
  Sort(Comparison);
end;

*/

class Commentaries {
    
    var items = [Commentary]()
    
    init() {
        load(path: dataPath)
        items.sort(by: {$0.name < $1.name} )
    }

    private func fileList(_ path: String) -> [String] {
        let extensions = [".unbound",".bblx",".bbli",".mybible",".SQLite3"]
        return getFileList(path).filter { $0.hasSuffix(extensions) }
    }
    
    private func load(path: String) {
        let files = fileList(path)
        for file in files {
            if !file.contains(".cmt.") && !file.contains(".commentaries.") { continue }
            if let item = Commentary(atPath: file) {
                items.append(item)
            }
        }
    }
    
}
