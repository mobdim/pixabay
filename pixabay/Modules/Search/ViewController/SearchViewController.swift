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
  private var data = [SearchModel]()
  private var total = 0
  private var rowsCount = 0
  
  
  fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Photo> = {
    let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
    
    let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
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

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = fetchedResultsController.sections else {
      return 0
    }
    
    let sectionInfo = sections[section]
    rowsCount = sectionInfo.numberOfObjects
    print("rowsCount: \(rowsCount)")
    return rowsCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.id) as? SearchCell else {
      return UITableViewCell(frame: .zero)
    }
    
    configureCell(cell, at: indexPath)
//    cell.delegate = self
//
//    if isLoadingCell(for: indexPath) {
//      cell.configure(model: .none, indexPath: indexPath)
//    } else {
//      cell.configure(model: .some(model: data[indexPath.row]), indexPath: indexPath)
//    }
    
    return cell
  }
}

extension SearchViewController {
  func load(id: Int) {
    guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    let managedContext = appdelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Photo.entity().name!)
    fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
    
    do {
      let result = try managedContext.fetch(fetchRequest)
      guard let objs = result as? [NSManagedObject], objs.count == 1, let obj = objs.first else {
        return
      }
      
      
      print("fetch: \(obj.value(forKey: #keyPath(Photo.id))!) - \(obj.value(forKey: #keyPath(Photo.tags))!)")
      
      
    } catch {
      print("fetch \(id) FAILED!!!")
    }
  }
  
  func save(model: SearchModel) {
    guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    let managedContext = appdelegate.persistentContainer.viewContext
    let photoEntity = NSEntityDescription.entity(forEntityName: Photo.entity().name!, in: managedContext)!
    
    let photo = NSManagedObject(entity: photoEntity, insertInto: managedContext)
    photo.setValue(model.id, forKey: #keyPath(Photo.id))
    photo.setValue(model.tags, forKey: #keyPath(Photo.tags))
    do {
      try managedContext.save()
      print("coredata saved: \(model)")
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}

extension SearchViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    print("prefetchRowsAt \(indexPaths)")
    if indexPaths.contains(where: isLoadingCell) {
      presenter.didNeedFetch()
    }
  }
}


extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    presenter.didClickSearchButton(searchText: searchBar.text)
  }
}

extension SearchViewController: SearchCellProtocol {
  func didLoaded(indexPath: IndexPath, image: UIImage) {
    print("didLoaded: \(indexPath) \(image)")
//    guard tableView.indexPathsForVisibleRows!.contains(indexPath) else {
//      return
//    }
//    if let cell = tableView.cellForRow(at: indexPath) as? SearchCell {
//      print("loaded: \(indexPath)")
//
////      cell.setNeedsLayout()
//    }
  }
  
  
}


// MARK: - SearchViewControllerInput

extension SearchViewController: SearchViewControllerInput {
  func set(models total: Int) {
    self.total = total
  }
  
  func removeAllModels() {
    self.data.removeAll()
  }
  
  func reloadData() {
    do {
      try fetchedResultsController.performFetch()
    } catch {
      let fetchError = error as NSError
      print("Unable to Save Photo")
      print("\(fetchError), \(fetchError.localizedDescription)")
    }
  }
  
  func reloadRows(indexes: [IndexPath]) {
    print("reloadRows: \(indexes)")
    let indexPathsToReload = visibleIndexPathsToReload(intersecting: indexes)
    print("indexPathsToReload: \(indexPathsToReload)")
    if indexPathsToReload.count > 0 {
      tableView.reloadRows(at: indexPathsToReload, with: .none)
    }
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

private extension SearchViewController {
  
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= rowsCount
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    print("indexPathsForVisibleRows: \(indexPathsForVisibleRows)")
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    print("indexPathsIntersection: \(indexPathsIntersection)")
    return Array(indexPathsIntersection)
  }
}

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
  }
}
