//
//  FavoriteItemCell.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/24.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class FavoriteItemCell: ItemCell {
  var item: FavoriteItem? {
    didSet {
      updateUI(item)
    }
  }
  
  lazy var deleteButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "delete"), for: .normal)
    button.addTarget(self, action: #selector(handleDeletion), for: .touchUpInside)
    return button
  }()
  
  @objc private func handleDeletion() {
    guard let item = self.item else { return }
    
    do {
      let realm = try Realm()
      try realm.write {
        realm.delete(item)
      }
    } catch let error as NSError {
      showError(error: error)
    }
  }
  
  override func configureViews() {
    super.configureViews()
    addSubview(deleteButton)
    deleteButton.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6), size: .init(width: 32, height: 32))
    deleteButton.centerYInSuperview()
  }
}
