//
//  SearchInteractor.swift
//  pixabay
//
//  Created by mobdim on 01/04/2019.
//  Copyright © 2019 pixabay. All rights reserved.
//

import Foundation

class SearchInteractor {
  let presenter: SearchInteractorOutput
    
  init(presenter: SearchInteractorOutput) {
    self.presenter = presenter
  }
}

// MARK: - SearchInteractorInput

extension SearchInteractor: SearchInteractorInput {

}
