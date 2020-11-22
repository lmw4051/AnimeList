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
  
  func getTopList(type: String, subType: String?, page: Int, completion: @escaping (AnimeResult?, Error?) -> Void) -> URLSessionDataTask {
    let page = String(page)
    var subUrlString = "\(type)/\(page)"
    
    if let subType = subType {
      subUrlString = subUrlString + "/\(subType)"
    }
    
    let url = URL(string: subUrlString, relativeTo: baseURL)!
    
    let task = session.dataTask(with: url) { (data, response, error) in
      guard let response = response as? HTTPURLResponse,
          response.statusCode == 200,
          error == nil,
          let data = data else {
          completion(nil, error)
          return
      }
      
      let decoder = JSONDecoder()
      
      do {
        let animeResult = try decoder.decode(AnimeResult.self, from: data)
        completion(animeResult, nil)
      } catch {
        completion(nil, error)
      }      
    }
    task.resume()
    return task
  }
}
