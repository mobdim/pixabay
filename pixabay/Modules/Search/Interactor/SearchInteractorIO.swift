//
//  SearchInteractorIO.swift
//  pixabay
//
//  Created by mobdim on 01/04/2019.
//  Copyright © 2019 pixabay. All rights reserved.
//

import Foundation

protocol SearchInteractorInput {
  func search(text: String, page: Int, per_page: Int)
  func clearDB()
}

protocol SearchInteractorOutput {
  func didSearchSuccess()
  func didSearchFailure(message: String?)
}
