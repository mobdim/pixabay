//
//  SearchViewControllerIO.swift
//  pixabay
//
//  Created by mobdim on 01/04/2019.
//  Copyright © 2019 pixabay. All rights reserved.
//

import Foundation

protocol SearchViewControllerInput {
  func setSearchBar(focus: Bool)
  func set(models data: [SearchModel])
  func set(models total: Int)
  func removeAllModels()
  
  func reloadRows(indexes: [IndexPath])
  func reloadData()
}

protocol SearchViewControllerOutput {
  func didReady()
  
  func didClickSearchButton(searchText: String?)
  func didNeedFetch()
}
