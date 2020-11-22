//
//  MockURLSession.swift
//  AnimteMangaTopItemListTests
//
//  Created by David on 2020/11/22.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

class MockURLSession: URLSession {
  var queue: DispatchQueue? = nil
  
  func givenDispatchQueue() {
    queue = DispatchQueue(label: "com.AnimeResultTests.MockSession")
  }
  
  override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
      return MockURLSessionDataTask(completionHandler: completionHandler,
                                    url: url,
                                    queue: queue)
  }
}
