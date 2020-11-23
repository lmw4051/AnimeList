//
//  HomeViewController.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/22.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController, UITableViewDelegate {
  // MARK: - Instance Properties
  var networkClient: JikanService = JikanClient.shared
  var dataTask: URLSessionDataTask?
  
  var mainType = "anime"
  var subType: String? = "airing"
  
  var items = [AnimeItem]()
  
  let tableView = UITableView(frame: .zero, style: .plain)
  let itemCellId = "SearchItemCell"
  var loadingView = UIActivityIndicatorView()
  
  var animeItems: Results<FavoriteItem>?
  private var notificationToken: NotificationToken?
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    setupFavoritesNotificationToken()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadTopItems()
  }
  
  // MARK: - Loading data from server
  func loadTopItems() {
    let page = items.count / 50 + 1
    var lastIndex = items.count - 1
    guard dataTask == nil else { return }
    
    loadingView.startAnimating()
    
    dataTask = networkClient.getTopList(type: mainType, subType: subType, page: page, completion: { animeResult, error in
      self.dataTask = nil
      
      if let error = error {
        DispatchQueue.main.async {
          self.showErrorAlert(error: error)
          self.loadingView.stopAnimating()
        }
        return
      }
      
      if let newItems = animeResult?.top {
        self.items += newItems
        var indexPaths = [IndexPath]()
        animeResult?.top?.forEach({ item in
          lastIndex += 1
          indexPaths.append(IndexPath(row: lastIndex, section: 0))
        })
        
        DispatchQueue.main.async {
          self.tableView.beginUpdates()
          self.tableView.insertRows(at: indexPaths, with: .automatic)
          self.tableView.endUpdates()
          self.loadingView.stopAnimating()
        }
      }
    })
  }
  
  // MARK: - Favorite Setup
  func setupFavoritesNotificationToken() {
    do {
      let realm = try Realm()
      animeItems = realm.objects(FavoriteItem.self)
      notificationToken = animeItems?.observe { [weak self] (changes: RealmCollectionChange) in
        guard let self = self else { return }
        
        switch changes {
        case .initial, .update(_, _, _, _):
          self.tableView.reloadData()
        case .error(let error):
          self.showErrorAlert(error: error)
        }
      }
    } catch let error as NSError {
      showErrorAlert(error: error)
    }
  }
  
  // MARK: - ConfigureViews
  private func configureViews() {
    view.addSubview(tableView)
    tableView.backgroundColor = .white
    tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(SearchItemCell.self, forCellReuseIdentifier: itemCellId)
  }
}

extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! SearchItemCell
    cell.item = items[indexPath.row]
    cell.isFavorite = animeItems?.first(where: { return $0.identity == items[indexPath.row].identity}) != nil
    
    if indexPath.row == items.count - 1 {
      loadTopItems()
    }
    
    return cell
  }
}
