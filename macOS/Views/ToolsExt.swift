//
//  Unbound Bible
//  Copyright © 2026 Vladimir Rybant. All rights reserved.
//

extension Tools {
    
       func get_Chapter(book: Int, chapter: Int) -> [String] {
           var result = [RowData]()
           let rowData = currBible.getChapter(book: book, chapter: chapter)
           
           let space = cocoaApp ? " " : ""
           let dot = cocoaApp ? "" : "."
           let eol = cocoaApp ? "\n" : ""

           for item in rowData {
               var item = item
               let text = "\(space)<l>\(item.number)\(dot)</l> \(item.text)\(eol)"
               item.text = text
               result.append(item)
           }
           
           return result.text
       }
    
}

