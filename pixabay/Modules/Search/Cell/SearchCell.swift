//
//  SearchCell.swift
//  pixabay
//
//  Created by Dmitriy Zadoroghnyy on 02/04/2019.
//  Copyright © 2019 Dmitriy Zadoroghnyy. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
  
  static let id = "searchCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView?.image = nil
    textLabel?.text = nil
  }
}

extension SearchCell {
  func set(model data: SearchModel) {
    UIImageView.load(urlString: data.imageUrl, completion: { [weak self] result in
      guard let self = self else {
        return
      }
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          self.imageView?.image = UIImage(data: data, scale: 1.0)
          self.setNeedsLayout()
          print("loaded image: \(data)")
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    })
    textLabel?.text = data.tags
  }
}
