//
//  TypeSubTypeInputView.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/24.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

enum SelectionType {
  case mainType
  case subType
}

protocol TypeSelectionViewdelegate: class {
  func presentPicker(selectType: SelectionType)
}

class TypeSelectionView: UIView {
  // MARK: - Instance Properties
  let typeTF = CustomTextField(padding: 12, cornerRadius: 6, backgroundColor: .init(white: 1, alpha: 0.3), textColor: .darkGray)
  let subTypeTF = CustomTextField(padding: 12, cornerRadius: 6, backgroundColor: .init(white: 1, alpha: 0.3), textColor: .darkGray)
  
  weak var delegate: TypeSelectionViewdelegate?
  
  // MARK: - View Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    
    typeTF.delegate = self
    subTypeTF.delegate = self
    
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

// MARK: - UITextFieldDelegate Methods
extension TypeSelectionView: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == typeTF {
      typeTF.resignFirstResponder()
      presentTypePicker()
    } else {
      subTypeTF.resignFirstResponder()
      presentSubtypePicker()
    }
    return false
  }
  
  private func presentTypePicker() {
    delegate?.presentPicker(selectType: .mainType)
  }
  
  private func presentSubtypePicker() {
    delegate?.presentPicker(selectType: .subType)
  }
}
