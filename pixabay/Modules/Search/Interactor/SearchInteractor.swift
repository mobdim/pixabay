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
    let urlString = "https://pixabay.com/api/?key=12057211-da8b15ee83b85dc84156454c8&q=\(text)&image_type=photo&pretty=true&page=1&per_page=10"
    
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
        let jsonObj = try JSONSerialization.jsonObject(with: data!)
        guard let json = jsonObj as? [String: AnyObject], let data = json["hits"] as? [[String: AnyObject]] else {
          self.presenter.didSearchFailure(message: "json error!")
          return
        }
        self.presenter.didSearchSuccess(json: data)
      } catch {
        self.presenter.didSearchFailure(message: "fail to parse json!")
      }

    }
    task.resume()
  }
  

}
