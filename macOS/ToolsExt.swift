//
//  Unbound Bible
//  Copyright © 2026 Vladimir Rybant. All rights reserved.
//

extension Tools {
    
    func get_Chapter(book: Int, chapter: Int) -> [String] {
        var result = [String]()
        let rowData = currBible.getChapter(book: book, chapter: chapter)

        for item in rowData {
           let string = " <l>\(item.number)</l> \(item.text)\n"
           result.append(string)
        }

        return result
    }

    func get_SearchList(string: String) -> [String] {
        var result = [String]()
        let list = tools.get_Search(string: string)
        
        for item in list {
            let string = "<l>\(item.link)</l> \(item.text)\n\n"
            result.append(string)
        }
        
        return result
    }

}

