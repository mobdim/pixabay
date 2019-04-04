//
//  SearchViewController.swift
//  pixabay
//
//  Created by mobdim on 01/04/2019.
//  Copyright © 2019 pixabay. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
  let presenter: SearchViewControllerOutput
  
  let searchBar = UISearchBar()
  let tableView: UITableView
  
  private var images: [NSManagedObject] = []
  private var rowsCount = 0
  
  
  fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Photo> = {
    let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
    
    let sortDescriptor = NSSortDescriptor(key: #keyPath(Photo.createdAt), ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: getViewContext()!, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchedResultsController.delegate = self
    
    return fetchedResultsController
  }()
  
  
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
    tableView.prefetchDataSource = self
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

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = fetchedResultsController.sections else {
      return 0
    }
    
    let sectionInfo = sections[section]
    rowsCount = sectionInfo.numberOfObjects
    return rowsCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.id) as? SearchCell else {
      return UITableViewCell(frame: .zero)
    }
    
    configureCell(cell, at: indexPath)
    
    return cell
  }
}

// MARK: - UITableViewDataSourcePrefetching

extension SearchViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//    print("prefetchRowsAt \(indexPaths)")
    if indexPaths.contains(where: isLoadingCell) {
//      print("didNeedFetch!!!!!!")
      presenter.didNeedFetch()
    }
  }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    presenter.didClickSearchButton(searchText: searchBar.text)
  }
}

// MARK: - SearchViewControllerInput

extension SearchViewController: SearchViewControllerInput {
  
  func reloadData() {
    do {
      try fetchedResultsController.performFetch()
    } catch {
      let fetchError = error as NSError
      print("Unable to Save Photo")
      print("\(fetchError), \(fetchError.localizedDescription)")
    }
  }
  
  func setSearchBar(focus: Bool) {
    if focus {
      searchBar.becomeFirstResponder()
    } else {
      searchBar.resignFirstResponder()
    }
  }
}

// MARK: - No protocol

private extension SearchViewController {
  
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
//    print("isLoadingCell: \(indexPath.row) | \(rowsCount - 1)")
    return indexPath.row >= rowsCount - 1
  }
}

// MARK: - NSFetchedResultsControllerDelegate

extension SearchViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
      case .insert:
        if let indexPath = newIndexPath {
          tableView.insertRows(at: [indexPath], with: .fade)
        }
        break;
      case .delete:
        if let indexPath = indexPath {
          tableView.deleteRows(at: [indexPath], with: .fade)
        }
        break;
      case .update:
        if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
          configureCell(cell, at: indexPath)
        }
        break;
      case .move:
        if let indexPath = indexPath {
          tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        if let newIndexPath = newIndexPath {
          tableView.insertRows(at: [newIndexPath], with: .fade)
        }
        break;
      @unknown default:
        fatalError("unknown!")
    }
  }
  
  func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
    let photo = fetchedResultsController.object(at: indexPath)
    
    cell.textLabel?.text = photo.tags
    
    if let data = photo.photo {
      cell.imageView?.image = UIImage(data: data as Data)
    } else {
      let task = load(urlString: photo.largeImageURL!) { result in
        switch result {
        case .success(let data):
          DispatchQueue.main.async {
            let photo = self.fetchedResultsController.object(at: indexPath)
            photo.photo = data as NSData
//            if let context = getViewContext() {
//              do {
//                try context.save()
//                print("Image save success!")
//              } catch let error {
//                print("Image fail save! \(error)")
//              }
//            }
          }
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
      task?.resume()
    }
  }
  
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
}
