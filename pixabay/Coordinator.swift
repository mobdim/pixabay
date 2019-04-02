//
//  Coordinator.swift
//  pixabay
//
//  Created by Dmitriy Zadoroghnyy on 01/04/2019.
//  Copyright © 2019 Dmitriy Zadoroghnyy. All rights reserved.
//

import UIKit

class Coordinator {
  static let manager = Coordinator()
  
  private var __window: UIWindow?
  private var window: UIWindow {
    return __window!
  }

  func start(with window: UIWindow) {
    __window = window

    window.rootViewController = navigationController
  }

  lazy var search = SearchHeader(root: self)
  
  lazy var navigationController = { AppNavigationController(rootViewController: search.currentController) }()
  
}


extension Coordinator: SearchHeaderOutput {
  
}
