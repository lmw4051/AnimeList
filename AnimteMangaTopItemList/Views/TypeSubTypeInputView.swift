//
//  TypeSubTypeInputView.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/24.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class TypeFilteredView: UIView {
  let typeTF = CustomTextField(padding: 12, cornerRadius: 6, backgroundColor: .init(white: 1, alpha: 0.3), textColor: .white)
  let subTypeTF = CustomTextField(padding: 12, cornerRadius: 6, backgroundColor: .init(white: 1, alpha: 0.3), textColor: .white)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    let inputStackView = vStack(
      hStack(generateTypeTitleLabel(title: "Type"), typeTF, spacing: 16),
      hStack(generateTypeTitleLabel(title: "Subtype"), subTypeTF, spacing: 16),
      spacing: 12,
      distribution: .fillEqually)
    inputStackView.layoutMargins = .init(top: 0, left: 16, bottom: 12, right: 16)
    inputStackView.isLayoutMarginsRelativeArrangement = true
  }    
  
  private func generateTypeTitleLabel(title: String) -> UILabel {
    let typeLabel = UILabel()
    typeLabel.text = title
    typeLabel.constrainWidth(constant: 80)
    return typeLabel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
