//
//  String+Date.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/23.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

extension String {
  func convertDateString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    if let date = dateFormatter.date(from:self) {
      dateFormatter.dateFormat = "yyyy-MM-dd"
      return dateFormatter.string(from: date)
    } else {
      return self
    }
  }
}
