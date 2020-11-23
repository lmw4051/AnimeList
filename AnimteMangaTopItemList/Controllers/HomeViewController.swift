//
//  HomeViewController.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/22.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  // MARK: - Instance Properties
  var networkClient: JikanService = JikanClient.shared
  var dataTask: URLSessionDataTask?
  
  var mainType = "anime"
  var subType: String? = "airing"
  
  var items = [AnimeItem]()
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadTopList()
  }
  
  // MARK: - Refresh
  func loadTopList() {
    let page = items.count / 50 + 1
    guard dataTask == nil else { return }
    
    dataTask = networkClient.getTopList(type: mainType, subType: subType, page: page, completion: { animeResult, error in
      self.dataTask = nil
    })
  }
}
