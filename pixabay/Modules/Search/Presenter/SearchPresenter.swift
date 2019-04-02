//
//  SearchPresenter.swift
//  pixabay
//
//  Created by mobdim on 01/04/2019.
//  Copyright © 2019 pixabay. All rights reserved.
//

import Foundation

class SearchPresenter {

  let root: SearchHeaderOutput
  var controller: SearchViewControllerInput {
    return __controller!
  }
  var interactor: SearchInteractorInput {
    return __interator!
  }

  private var __controller: SearchViewControllerInput?
  private var __interator: SearchInteractorInput?
    
  func __set_missing(controller: SearchViewControllerInput, interactor: SearchInteractorInput) {
    __controller = controller
    __interator = interactor
  }
    
  init(root: SearchHeaderOutput) {
    self.root = root
  }
}

// MARK: - SearchInteractorOutput

extension SearchPresenter: SearchInteractorOutput {

}

// MARK: - SearchViewControllerOutput

extension SearchPresenter: SearchViewControllerOutput {
  
  func didReady() {
    controller.setSearchBar(focus: true)
  }
}
