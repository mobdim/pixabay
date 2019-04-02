//
// Created by Dmitriy Zadoroghnyy on 2019-04-02.
// Copyright (c) 2019 Dmitriy Zadoroghnyy. All rights reserved.
//

import UIKit

class AppNavigationController: UINavigationController {
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  override func viewDidLoad() {
    let searchBar = UISearchBar()
    searchBar.showsCancelButton = false
    navigationItem.titleView = searchBar
  }
}


