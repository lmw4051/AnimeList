//
//  HomeViewController.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/22.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
  // MARK: - Instance Properties
  var networkClient: JikanService = JikanClient.shared
  var dataTask: URLSessionDataTask?
  
  var mainType = "anime"
  var subType: String? = "airing"
  
  var items = [AnimeItem]()
  
  let tableView = UITableView(frame: .zero, style: .plain)
  var activityIndicatorView = UIActivityIndicatorView()
  
  var animeItems: Results<FavoriteItem>?
  private var notificationToken: NotificationToken?
  
  let filteredView = TypeSelectionView()
  
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
    
    activityIndicatorView.startAnimating()
    
    dataTask = networkClient.getTopList(type: mainType, subType: subType, page: page, completion: { [weak self] animeResult, error in
      guard let self = self else { return }
      self.dataTask = nil
      
      if let error = error {
        DispatchQueue.main.async {
          self.showErrorAlert(error: error)
          self.activityIndicatorView.stopAnimating()
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
          self.activityIndicatorView.stopAnimating()
        }
      }
    })
  }
  
  // MARK: - Favorite Setup
  private func setupFavoritesNotificationToken() {
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
    let navBarView = UIView()
    navBarView.backgroundColor = .rgb(red: 255, green: 128, blue: 0)
    view.addSubview(navBarView)
    navBarView.setupShadow(opacity: 0.5, radius: 5)
    navBarView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -80, right: 0))
    
    filteredView.typeTF.text = mainType
    filteredView.subTypeTF.text = subType
    navBarView.addSubview(filteredView)
    filteredView.fillSuperviewSafeAreaLayoutGuide()    
    
    view.addSubview(tableView)
    tableView.backgroundColor = .white
    tableView.anchor(top: navBarView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(SearchItemCell.self, forCellReuseIdentifier: SearchItemCell.identifier)
  }
}

// MARK: - UITableViewDataSource Methods
extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchItemCell.identifier, for: indexPath) as! SearchItemCell
    cell.item = items[indexPath.row]
    cell.isFavorite = animeItems?.first(where: { return $0.identity == items[indexPath.row].identity}) != nil
    
    if indexPath.row == items.count - 1 {
      loadTopItems()
    }
    
    return cell
  }
}

// MARK: - UITableViewDelegate Methods
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerView = UIView()
    footerView.addSubview(activityIndicatorView)
    activityIndicatorView.color = .lightGray
    activityIndicatorView.fillSuperview()
    activityIndicatorView.constrainHeight(constant: 24)
    return footerView
  }
}
