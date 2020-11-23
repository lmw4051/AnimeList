//
//  UIColor+Additions.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/23.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

extension UIColor {
  static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
  }
}
