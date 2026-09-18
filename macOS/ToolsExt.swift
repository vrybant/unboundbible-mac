//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

extension Tools {
    
    func get_Chapter(book: Int, chapter: Int) -> String {
        return currBible.getChapter(book: book, chapter: chapter)
            .map { " <l>\($0.number)</l> \($0.text)\n" }
            .joined()
    }

    func get_SearchList(string: String) -> (string: String, count: Int) {
        let list = get_Search(string: string)
            .map {
                let link = currBible.verseToString($0.verse) ?? "Unknown"
                return "<l>\(link)</l> \($0.text)\n\n"
            }
        
        return (list.joined(), list.count)
    }

}

