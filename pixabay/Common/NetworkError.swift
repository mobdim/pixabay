//
//  NetworkError.swift
//  pixabay
//
//  Created by Dmitriy Zadoroghnyy on 02/04/2019.
//  Copyright © 2019 Dmitriy Zadoroghnyy. All rights reserved.
//

import Foundation

enum DataError: Error {
  case invalidURL
  case requestFail
  case jsonError
  case errorParseJson
}
