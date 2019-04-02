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
  func didSearchFailure(message: String?) {
    print("fail: \(message ?? "error")")
  }
  
  func didSearchSuccess(json: [[String: AnyObject]]) {
    print("success: \(json)")
  }
}

// MARK: - SearchViewControllerOutput

extension SearchPresenter: SearchViewControllerOutput {
  func didClickSearchButton(searchText: String?) {
    
    guard let searchText = searchText else {
      return
    }
    
    interactor.search(text: searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+"))
    
    controller.setSearchBar(focus: false)
  }
  
  
  func didReady() {
    controller.setSearchBar(focus: true)
  }
}
