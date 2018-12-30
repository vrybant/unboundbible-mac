//
//  types.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

var recentList : [URL] = []

enum FileFormat {
    case unbound, mybible
}

struct StringAlias {
    var bible = "Bible"
    var book = "Book"
    var chapter = "Chapter"
    var verse = "Verse"
    var text = "Scripture"
    var details = "Details"
}

var mybibleStringAlias = StringAlias(
    bible : "verses",
    book : "book_number",
    chapter : "chapter",
    verse : "verse",
    text : "text",
    details : "info"
)

struct CommentaryAlias {
    var commentary = "commentary"
    var id = "id"
    var book = "book"
    var chapter = "chapter"
    var fromverse = "fromverse"
    var toverse = "toverse"
    var data = "data"
}

var mybibleCommentaryAlias = CommentaryAlias(
    commentary: "commentaries",
    id: "id",
    book: "book_number",
    chapter: "chapter_number_from",
    fromverse: "verse_number_from",
//  chapter: "chapter_number_to"
    toverse: "verse_number_to",
//  marker : "marker"
    data: "text"
)

struct DictionaryAlias {
    var dictionary = "Dictionary"
    var word = "Word"
    var data = "Data"
}

var mybibleDictionaryAlias = DictionaryAlias(
    dictionary : "dictionary",
    word : "topic",
    data : "definition"
)

struct Verse {
    var book    = 0
    var chapter = 0
    var number  = 0
    var count   = 0
}

struct Book {
    var title   = ""
    var abbr    = ""
    var number  = 0
    var id      = 0
    var sorting = 0
}

struct Content {
    var verse = Verse()
    var text: String = ""
}

let myBibleArray : [Int] = [0,
        010,020,030,040,050,060,070,080,090,100,110,120,130,140,150,160,190,220,230,240,
        250,260,290,300,310,330,340,350,360,370,380,390,400,410,420,430,440,450,460,470,
        480,490,500,510,520,530,540,550,560,570,580,590,600,610,620,630,640,650,660,670,
        680,690,700,710,720,730,165,170,180,270,280,315,320,462,464,466,468,790,467]

let sortArrayEN : [Int] = [0,
        01,02,03,04,05,06,07,08,09,10,11,12,13,14,78,15,16,67,68,69,
        17,74,75,76,79,77,18,19,20,21,22,70,71,23,24,25,72,73,26,27,
        28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,
        48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66]

let sortArrayRU : [Int] = [0,
        01,02,03,04,05,06,07,08,09,10,11,12,13,14,78,15,16,67,68,69,
        17,18,19,20,21,22,70,71,23,24,25,72,73,26,27,28,29,30,31,32,
        33,34,35,36,37,38,39,74,75,76,79,77,40,41,42,43,44,59,60,61,
        62,63,64,65,45,46,47,48,49,50,51,52,53,54,55,56,57,58,66]

let bibleHubArray : [String] = ["",
        "genesis","exodus","leviticus","numbers","deuteronomy","joshua","judges","ruth","1_samuel","2_samuel",
        "1_kings","2_kings","1_chronicles","2_chronicles","ezra","nehemiah","esther","job","psalms","proverbs",
        "ecclesiastes","songs","isaiah","jeremiah","lamentations","ezekiel","daniel","hosea","joel","amos",
        "obadiah","jonah","micah","nahum","habakkuk","zephaniah","haggai","zechariah","malachi","matthew",
        "mark","luke","john","acts","romans","1_corinthians","2_corinthians","galatians","ephesians","philippians",
        "colossians","1_thessalonians","2_thessalonians","1_timothy","2_timothy","titus","philemon","hebrews",
        "james","1_peter","2_peter","1_john","2_john","3_john","jude","revelation"]

func isNewTestament(_ n: Int) -> Bool {
    return (n >= 40) && (n <= 66)
}

func isOldTestament(_ n: Int) -> Bool {
    return n < 40
}

func isApocrypha(_ n: Int) -> Bool {
    return n > 66
}

