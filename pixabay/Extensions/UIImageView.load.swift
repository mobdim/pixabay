//
//  UIImageView.load.swift
//  pixabay
//
//  Created by Dmitriy Zadoroghnyy on 02/04/2019.
//  Copyright © 2019 Dmitriy Zadoroghnyy. All rights reserved.
//

import UIKit


extension UIImageView {
  static func load(urlString: String, completion: @escaping (Result<Data, DataError>) -> Void) {
    guard let url = URL(string: urlString) else {
      completion(.failure(.invalidURL))
      return
    }
    
    let urlRequest = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      
      guard let data = data, error == nil else {
        completion(.failure(.requestFail))
        return
      }
      
      completion(.success(data))
    }
    task.resume()
  }
}
