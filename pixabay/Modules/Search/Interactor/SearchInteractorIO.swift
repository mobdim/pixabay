//
//  SearchInteractorIO.swift
//  pixabay
//
//  Created by mobdim on 01/04/2019.
//  Copyright © 2019 pixabay. All rights reserved.
//

import Foundation

protocol SearchInteractorInput {
  func search(text: String)
}

protocol SearchInteractorOutput {
  func didSearchSuccess(json: Dictionary<String, Any?>)
  func didSearchFailure(message: String?)
}
