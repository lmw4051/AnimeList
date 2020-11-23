//
//  UIViewController+Additions.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/23.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

extension UIViewController {
  func showErrorAlert(error: Error) {
    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
}
