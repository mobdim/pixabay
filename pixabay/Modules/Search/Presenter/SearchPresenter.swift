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
  
  fileprivate var searchText = ""
  static let per_page = 20
  var currentPage = 1
}

// MARK: - SearchInteractorOutput

extension SearchPresenter: SearchInteractorOutput {
  
  func didSearchFailure(message: String?) {
    print("fail: \(message ?? "error")")
  }
  
  func didSearchSuccess() {
    DispatchQueue.main.async {
      self.controller.reloadData()
    }
  }
}

// MARK: - SearchViewControllerOutput

extension SearchPresenter: SearchViewControllerOutput {
  func didNeedFetch() {
    currentPage += 1
    interactor.search(text: self.searchText, page: currentPage, per_page: SearchPresenter.per_page)
  }
    
  func didClickSearchButton(searchText: String?) {
    
    guard let searchText = searchText else {
      return
    }
    interactor.clearDB()
    controller.reloadData()
    currentPage = 1
    self.searchText = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
    interactor.search(text: self.searchText, page: currentPage, per_page: SearchPresenter.per_page)
    
    controller.setSearchBar(focus: false)
  }
  
  func didReady() {
    controller.setSearchBar(focus: true)
  }
}
