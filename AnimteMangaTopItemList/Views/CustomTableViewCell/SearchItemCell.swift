//
//  SearchItemCell.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/23.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class SearchItemCell: ItemCell {
  var item: AnimeItem? {
    didSet {
      updateUI(item)
    }
  }
}
