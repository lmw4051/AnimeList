//
//  TypeSubTypeInputView.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/24.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class TypeSelectionView: UIView {
  // MARK: - Instance Properties
  let typeTF = CustomTextField(padding: 12, cornerRadius: 6, backgroundColor: .init(white: 1, alpha: 0.3), textColor: .darkGray)
  let subTypeTF = CustomTextField(padding: 12, cornerRadius: 6, backgroundColor: .init(white: 1, alpha: 0.3), textColor: .darkGray)
  
  // MARK: - View Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    let inputStackView = vStack(
      hStack(createTypeTitleLabel(title: "Type"), typeTF, spacing: 8),
      hStack(createTypeTitleLabel(title: "Subtype"), subTypeTF, spacing: 8), spacing: 8, distribution: .fillEqually)
    inputStackView.layoutMargins = .init(top: 0, left: 16, bottom: 12, right: 16)
    inputStackView.isLayoutMarginsRelativeArrangement = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: - Helper Methods
  private func createTypeTitleLabel(title: String) -> UILabel {
    let typeLabel = UILabel()
    typeLabel.text = title
    typeLabel.constrainWidth(constant: 80)
    return typeLabel
  }
}
