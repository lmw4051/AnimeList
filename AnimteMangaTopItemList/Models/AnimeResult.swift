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

protocol Anime {
    var title: String? { get }
    var url: String? { get }
    var imageUrl: String? { get }
    var type: String? { get }
    var startDate: String? { get }
    var endDate: String? { get }
    var identity: Int { get }
    var rank: Int { get }
}

struct AnimeItem: Decodable, Equatable, Anime {
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
