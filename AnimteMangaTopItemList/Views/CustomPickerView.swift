//
//  CustomPickerView.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/24.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
protocol CustomPickerViewDelegate: class {
  func changeSelectionType(type: SelectionType, value: String)
}

class CustomPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
  let pickerHeight:CGFloat = 260
  let types: [String]?
  let originalIndex: Int
  let selectionType: SelectionType
  
  weak var delegate: CustomPickerViewDelegate?
  
  var pickerViewBottomAnchor: NSLayoutConstraint?
  
  let pickerView = UIPickerView()
  let backView = UIView()
  
  let doneButton: UIButton = {
    let btn = UIButton(type: .system)
    btn.setTitle("Done", for: .normal)
    btn.setTitleColor(.white, for: .normal)
    btn.isHidden = true
    btn.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
    return btn
  }()
  
  init(types: [String], selectionType: SelectionType, value: String?) {
    self.types = types
    self.originalIndex = types.firstIndex(of: value ?? "") ?? 0
    self.selectionType = selectionType
    super.init(frame: .zero)
    
    backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    backView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
    backView.alpha = 0
    addSubview(backView)
    backView.fillSuperview()
    
    pickerView.delegate = self
    pickerView.dataSource = self
    
    addSubview(pickerView)
    pickerView.backgroundColor = UIColor(red: 94/255, green: 137/255, blue: 214/255, alpha: 1)
    pickerView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .zero, size: .init(width: 0, height: pickerHeight))
    pickerViewBottomAnchor = pickerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: pickerHeight)
    pickerViewBottomAnchor?.isActive = true
    
    addSubview(doneButton)
    doneButton.anchor(top: pickerView.topAnchor, leading: nil, bottom: nil, trailing: pickerView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 16), size: .zero)
  }
  
  func presentInAnimation() {
    pickerView.selectRow(originalIndex, inComponent: 0, animated: false)
    pickerViewBottomAnchor?.constant = 0
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.layoutIfNeeded()
      self.backView.alpha = 1
    }, completion: nil)
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.doneButton.isHidden = row == originalIndex
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return types?.count ?? 0
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return types?[row] ?? ""
  }
  
  @objc private func handleDone() {
    dismiss()
    guard let selectedType = types?[pickerView.selectedRow(inComponent: 0)] else { return }
    self.delegate?.changeSelectionType(type: selectionType, value: selectedType)
  }
  
  @objc private func dismiss() {
    pickerViewBottomAnchor?.constant = pickerHeight
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.layoutIfNeeded()
      self.backView.alpha = 0
    }) { (_) in
      self.removeFromSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
