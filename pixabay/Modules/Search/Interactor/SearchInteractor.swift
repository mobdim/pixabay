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
  func search(text: String) {
    let urlString = "https://pixabay.com/api/?key=12057211-da8b15ee83b85dc84156454c8&q=\(text)&image_type=photo&pretty=true"
    
    guard let url = URL(string: urlString) else {
      presenter.didSearchFailure(message: "invalid URL")
      return
    }
    let urlRequest = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, responce, error) in
      
      guard let self = self else {
        return
      }
      
      if error != nil {
        self.presenter.didSearchFailure(message: "request fail")
      }
      do {
        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
        self.presenter.didSearchSuccess(json: json as! Dictionary<String, Any?>)
      } catch {
        self.presenter.didSearchFailure(message: "fail to parse json!")
      }

    }
    task.resume()
  }
  

}
