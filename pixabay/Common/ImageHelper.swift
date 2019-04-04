//
//  ImageHelper.swift
//  pixabay
//
//  Created by Dmitriy Zadoroghnyy on 04/04/2019.
//  Copyright © 2019 Dmitriy Zadoroghnyy. All rights reserved.
//

import Foundation

func load(urlString: String, completion: @escaping (Result<Data, DataError>) -> Void) -> URLSessionDataTask? {
  guard let url = URL(string: urlString) else {
    completion(.failure(.invalidURL))
    return .none
  }
  
  let urlRequest = URLRequest(url: url)
  let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
    
    guard let data = data, error == nil else {
      completion(.failure(.requestFail))
      return
    }
    
    completion(.success(data))
  }
  return task
}