//
//  MockURLSessionDataTask.swift
//  AnimteMangaTopItemListTests
//
//  Created by David on 2020/11/22.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
  typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
  var completionHandler: DataTaskResult
  var url: URL
  
  init(completionHandler: @escaping DataTaskResult,
       url: URL,
       queue: DispatchQueue?) {
    if let queue = queue {
      self.completionHandler = { data, response, error in
        queue.async {
          completionHandler(data, response, error)
        }
      }
    } else {
      self.completionHandler = completionHandler
    }
    
    self.url = url
    super.init()
  }
  
  var calledResume = false
  
  override func resume() {
    calledResume = true
  }
}
