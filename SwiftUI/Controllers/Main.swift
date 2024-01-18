//
//  SwiftUI
//
//  Copyright ©  Vladimir Rybant. All rights reserved.
//

import Foundation
import Observation

@Observable
class MainStore {
    var book = 1
    var chapter = 1
}

extension MainStore {
    var infoString: String {
        tools.get_Info(book: book, chapter: chapter)
    }
}

/*
abstract class MainControllerBase with Store {
  @observable
  int book = 1;

  @observable
  int chapter = 1;

  @computed
  String get infoString => GetIt.I<Tools>().getInfo(book, chapter);

  @computed
  List<String> get content => GetIt.I<Tools>().get_Chapter(book, chapter);

  int chaptersCount(int book) => GetIt.I<Tools>().chaptersCount(book);
  String getTitle(int book) => GetIt.I<Tools>().getTitle(book);

  @action
  void update({
    int? book,
    int? chapter,
  }) {
    this.book = book ?? this.book;
    this.chapter = chapter ?? 1;
  }

  @action
  void refresh() {
    final temp = book;
    this.book = -1;
    this.book = temp;
  }
}

*/
