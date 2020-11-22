//
//  AnimeResult.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/22.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

struct AnimeResult: Decodable {
  let top: [AnimeItem]?
}

struct AnimeItem: Decodable {
  let title: String?
  let url: String?
  let imageUrl: String?
  let type: String?
  let startDate: String?
  let endDate: String?
  let identity: Int
  let rank: Int
  
  private enum CodingKeys: String, CodingKey {
    case title
    case url
    case imageUrl = "image_url"
    case type
    case startDate = "start_date"
    case endDate = "end_date"
    case identity = "mal_id"
    case rank
  }
}
