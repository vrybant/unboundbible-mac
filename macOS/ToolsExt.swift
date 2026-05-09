//
//  Unbound Bible
//  Copyright © 2026 Vladimir Rybant. All rights reserved.
//

extension Tools {
    
       func get_Chapter(book: Int, chapter: Int) -> [String] {
           var result = [String]()
           let rowData = currBible.getChapter(book: book, chapter: chapter)

           for item in rowData {
               let text = " <l>\(item.number)</l> \(item.text)\n"
               result.append(text)
           }
           
           return result
       }
    
}

