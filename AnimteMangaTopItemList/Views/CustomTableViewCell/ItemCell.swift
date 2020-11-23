//
//  ItemCell.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/23.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import SDWebImage

class ItemCell: UITableViewCell {
  // MARK: - UI Properties
  let thumbnailImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.backgroundColor = .lightGray
    iv.clipsToBounds = true
    return iv
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.textAlignment = .center
    label.numberOfLines = 2
    label.font = .systemFont(ofSize: 18, weight: .semibold)
    return label
  }()
  
  let dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = .rgb(red: 94, green: 137, blue: 214)
    label.font = .systemFont(ofSize: 16)
    return label
  }()
  
  let rankLabel: UILabel = {
      let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 14)
      label.textColor = .lightGray
      return label
  }()
  
  let typeLabel: UILabel = {
      let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 14)
      label.textColor = .lightGray
      label.text = "TV"
      return label
  }()
  
  func updateUI(_ item: AnimeItem?) {
    if let imageUrl = item?.imageUrl {
      thumbnailImageView.sd_setImage(with: URL(string: imageUrl))
    } else {
      thumbnailImageView.image = nil
    }
    
    nameLabel.text = item?.title
    dateLabel.text = "\(item?.startDate?.convertDateString() ?? "")" + " - " + "\(item?.endDate?.convertDateString() ?? "")"
    
    if let rank = item?.rank {
        rankLabel.text = "Rank: \(rank)"
    } else {
        rankLabel.text = "Rank: -"
    }
    typeLabel.text = item?.type ?? "-"
  }
  
  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureViews() {
    backgroundColor = .white
    let containerView = UIView()
    let stackView = containerView.hStack(
      thumbnailImageView,
      containerView.vStack(nameLabel, dateLabel, rankLabel, typeLabel, spacing: 2, alignment: .center), spacing: 12, alignment:.center)
    stackView.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 32)
    stackView.isLayoutMarginsRelativeArrangement = true
    thumbnailImageView.constrainWidth(constant: 80)
    thumbnailImageView.constrainHeight(constant: 80)
    addSubview(containerView)
    containerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 8, right: 0))
  }
}
