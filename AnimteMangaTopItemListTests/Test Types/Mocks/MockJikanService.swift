//
//  MockJikanService.swift
//  AnimteMangaTopItemListTests
//
//  Created by David on 2020/11/22.
//  Copyright © 2020 David. All rights reserved.
//

import XCTest
@testable import AnimteMangaTopItemList

class MockJikanService: JikanService {
  var getAnimeResultCallCount = 0
  var getAnimeResultDataTask = URLSessionDataTask()
  var getAnimeResultCompletion: ((AnimeResult?, Error?) -> Void)!
  
  func getTopList(type: String, subType: String?, page: Int, completion: @escaping (AnimeResult?, Error?) -> Void) -> URLSessionDataTask {
    getAnimeResultCallCount += 1
    getAnimeResultCompletion = completion
    return getAnimeResultDataTask
  }
}
