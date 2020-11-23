//
//  FavoriteItem.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/24.
//  Copyright © 2020 David. All rights reserved.
//

import RealmSwift

class FavoriteItem: Object, Anime {
  @objc dynamic var title: String?
  @objc dynamic var url: String?
  @objc dynamic var imageUrl: String?
  @objc dynamic var type: String?
  @objc dynamic var startDate: String?
  @objc dynamic var endDate: String?
  @objc dynamic var identity = 0
  @objc dynamic var rank: Int = 0
  
  convenience init(item: AnimeItem) {
    self.init()
    self.title = item.title
    self.identity = item.identity
    self.url = item.url
    self.imageUrl = item.imageUrl
    self.type = item.type
    self.startDate = item.startDate
    self.endDate = item.endDate
    self.rank = item.rank
  }
  
  override class func primaryKey() -> String? {
    return "identity"
  }
}
