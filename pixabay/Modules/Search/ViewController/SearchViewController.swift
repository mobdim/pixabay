//
//  SearchViewController.swift
//  pixabay
//
//  Created by mobdim on 01/04/2019.
//  Copyright © 2019 pixabay. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {
  let presenter: SearchViewControllerOutput
  
  let searchBar = UISearchBar()
  let tableView: UITableView
  
  fileprivate var data = [SearchModel]()
  
  override func loadView() {
    super.loadView()

    view = UIView(frame: .zero)
    view.backgroundColor = .white
  }
  
  init(presenter: SearchViewControllerOutput, nibName: String?, bundle: Bundle?) {
    self.presenter = presenter
    tableView = UITableView(frame: .zero)
    super.init(nibName: nibName, bundle: bundle)
  }
    
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchBar.showsCancelButton = false
    navigationItem.titleView = searchBar
    searchBar.delegate = self
    searchBar.returnKeyType = .search
    
    tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.id)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .white
    tableView.dataSource = self
    view.addSubview(tableView)
    if #available(iOS 11, *) {
      tableView.contentInsetAdjustmentBehavior = .never
    } else {
      automaticallyAdjustsScrollViewInsets = false
    }
        
    let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    let topConstraint: NSLayoutConstraint
    if #available(iOS 11, *) {
      topConstraint = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: edgeInsets.top)
    } else {
      topConstraint = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: edgeInsets.top)
    }
    let leftConstraint = NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: edgeInsets.left)
    let rightConstraint = NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -edgeInsets.right)
    let bottomConstraint = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -edgeInsets.bottom)
    
    let constraints = [topConstraint, leftConstraint, rightConstraint, bottomConstraint]
    
    view.addConstraints(constraints)
    
    presenter.didReady()
  }
  
}

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.id) as? SearchCell else {
      return UITableViewCell(frame: .zero)
    }
    
    cell.set(model: data[indexPath.row])
    
    return cell
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    presenter.didClickSearchButton(searchText: searchBar.text)
  }
}

// MARK: - SearchViewControllerInput

extension SearchViewController: SearchViewControllerInput {
  func reloadData() {
    tableView.reloadData()
  }
  
  func set(models data: [SearchModel]) {
    self.data = data
  }
  
  func setSearchBar(focus: Bool) {
    if focus {
      searchBar.becomeFirstResponder()
    } else {
      searchBar.resignFirstResponder()
    }
  }
  

}
