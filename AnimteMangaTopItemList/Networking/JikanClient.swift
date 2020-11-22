//
//  JikanClient.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/22.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

protocol JikanService {
  func getTopList(type: String, subType: String?, page: Int, completion: @escaping (AnimeResult?, Error?) -> Void) -> URLSessionDataTask
}

class JikanClient {
  let baseURL: URL
  let session: URLSession
  let responseQueue: DispatchQueue?
  
  static let shared = JikanClient(
    baseURL: URL(string: "https://api.jikan.moe/v3/top/")!,
    session: .shared,
    responseQueue: .main
  )
  
  init(baseURL: URL,
       session: URLSession,
       responseQueue: DispatchQueue?) {
    self.baseURL = baseURL
    self.session = session
    self.responseQueue = responseQueue
  }
  
  func getTopList(type: String, subType: String?, page: Int, completion: @escaping (AnimeResult?, Error?) -> Void) -> URLSessionDataTask {
    let page = String(page)
    var subUrlString = "\(type)/\(page)"
    
    if let subType = subType {
      subUrlString = subUrlString + "/\(subType)"
    }
    
    let url = URL(string: subUrlString, relativeTo: baseURL)!
    
    let task = session.dataTask(with: url) { [weak self] (data, response, error) in
      
      guard let self = self else { return }
      
      guard let response = response as? HTTPURLResponse,
          response.statusCode == 200,
          error == nil,
          let data = data else {
            self.dispatchResult(error: error, completion: completion)
          return
      }
      
      let decoder = JSONDecoder()
      
      do {
        let animeResult = try decoder.decode(AnimeResult.self, from: data)
        self.dispatchResult(models: animeResult, completion: completion)
      } catch {
        self.dispatchResult(error: error, completion: completion)
      }      
    }
    task.resume()
    return task
  }
  
  private func dispatchResult<Type>(
    models: Type? = nil,
    error: Error? = nil,
    completion: @escaping (Type?, Error?) -> Void) {
    
    guard let responseQueue = self.responseQueue else {
      completion(models, error)
      return
    }
    responseQueue.async {
      completion(models, error)
    }
  }
}

extension JikanClient: JikanService { }
