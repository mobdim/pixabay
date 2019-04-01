//
//  SearchViewController.swift
//  pixabay
//
//  Created by mobdim on 01/04/2019.
//  Copyright © 2019 pixabay. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {
  let presenter: SearchViewControllerOutput

  init(presenter: SearchViewControllerOutput, nibName: String?, bundle: Bundle?) {
    self.presenter = presenter
    super.init(nibName: nibName, bundle: bundle)
  }
    
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.didReady()
  }
}

// MARK: - SearchViewControllerInput

extension SearchViewController: SearchViewControllerInput {

}
