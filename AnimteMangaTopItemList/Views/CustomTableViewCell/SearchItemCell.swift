//
//  SearchItemCell.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/23.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import RealmSwift

class SearchItemCell: ItemCell {
  var item: AnimeItem? {
    didSet {
      updateUI(item)
    }
  }
  
  var isFavorite = false {
    didSet {
      likeButton.setImage(isFavorite ? UIImage(named: "heart_fill") : UIImage(named: "heart"), for: .normal)
    }
  }
  
  lazy var likeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "heart"), for: .normal)
    button.addTarget(self, action: #selector(handleLikeAndDisLike), for: .touchUpInside)
    return button
  }()
  
  @objc private func handleLikeAndDisLike() {
    guard let item = self.item else { return }
    
    do {
      let realm = try Realm()
      if isFavorite {
        if let favoriteItem = realm.objects(FavoriteItem.self).first(where: {$0.identity == item.identity}) {
          try realm.write {
            realm.delete(favoriteItem)
          }
        }
      } else {
        try realm.write {
          realm.add(FavoriteItem(item: item))
        }
      }
    } catch let error as NSError {
      showError(error: error)
    }
  }
  
  override func configureViews() {
    super.configureViews()
    addSubview(likeButton)
    likeButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 8),
                      size: .init(width: 35, height: 35))
  }
}
