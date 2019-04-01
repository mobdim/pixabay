//
//  SearchHeader.swift
//  pixabay
//
//  Created by mobdim on 01/04/2019.
//  Copyright © 2019 pixabay. All rights reserved.
//

import UIKit

class SearchHeader {

  let controller: SearchViewController
  let presenter: SearchPresenter
  let interactor: SearchInteractor

  init(root: SearchHeaderOutput) {
    presenter = SearchPresenter(root: root)
    interactor = SearchInteractor(presenter: presenter)
    controller = SearchViewController(presenter: presenter, nibName: nil, bundle: nil)
    presenter.__set_missing(controller: controller, interactor: interactor)
  }

  var currentController: UIViewController {
    return controller
  }
}

// MARK: - SearchHeaderInput

extension SearchHeader: SearchHeaderInput {

}
