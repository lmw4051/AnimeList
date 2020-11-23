//
//  CustomTextField.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/24.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
  let padding: CGFloat
  
  init(padding: CGFloat = 0, cornerRadius: CGFloat = 0, backgroundColor: UIColor = .clear, text: String? = nil, textColor: UIColor?) {
    self.padding = padding
    super.init(frame: .zero)
    layer.cornerRadius = cornerRadius
    self.backgroundColor = backgroundColor
    self.textColor = textColor
    self.text = text
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: 12, dy: 0)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: 12, dy: 0)
  }
}
