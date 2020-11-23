//
//  FavoritesViewController.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/22.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritesViewController: UITableViewController {
  private var animesItems: Results<FavoriteItem>?
  private var notificationToken: NotificationToken?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    setupFavoritesNotificationToken()
  }
  
  func setupTableView() {
    tableView.register(FavoriteItemCell.self, forCellReuseIdentifier: FavoriteItemCell.identifier)
  }
  
  private func setupFavoritesNotificationToken() {
    do {
      let realm = try Realm()
      animesItems = realm.objects(FavoriteItem.self)
      notificationToken = animesItems?.observe { [weak self] (changes: RealmCollectionChange) in
        guard let self = self else { return }
                
        switch changes {
        case .initial:
          self.tableView.reloadData()
        case .update(_, let deletions, let insertions, let modifications):
          self.tableView.beginUpdates()
          self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                               with: .automatic)
          self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                               with: .automatic)
          self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                               with: .automatic)
          self.tableView.endUpdates()
        case .error(let error):
          self.showErrorAlert(error: error)
        }
      }
    } catch let error as NSError {
      showErrorAlert(error: error)
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return animesItems?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteItemCell.identifier, for: indexPath) as! FavoriteItemCell
    cell.item = animesItems?[indexPath.row]
    return cell
  }
  
}

