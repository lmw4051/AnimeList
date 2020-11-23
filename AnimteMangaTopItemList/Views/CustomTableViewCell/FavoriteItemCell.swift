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
}
