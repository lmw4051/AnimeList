//
//  JikanClient.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/22.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

class JikanClient {
  let baseURL: URL
  let session: URLSession
  
  init(baseURL: URL, session: URLSession) {
    self.baseURL = baseURL
    self.session = session
  }
  
  func getTopList(completion: @escaping ([AnimeItem]?, Error?) -> Void) -> URLSessionDataTask {
    let url = URL(string: "anime", relativeTo: baseURL)!
    let task = session.dataTask(with: url) { (data, response, error) in
      guard let response = response as? HTTPURLResponse,
          response.statusCode == 200,
          error == nil else {
          completion(nil, error)
          return
      }
    }
    task.resume()
    return task
  }
}
