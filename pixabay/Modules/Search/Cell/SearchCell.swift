//
//  SearchCell.swift
//  pixabay
//
//  Created by Dmitriy Zadoroghnyy on 02/04/2019.
//  Copyright © 2019 Dmitriy Zadoroghnyy. All rights reserved.
//

import UIKit
import CoreData

protocol SearchCellProtocol {
  func didLoaded(indexPath: IndexPath, image: UIImage)
}

class SearchCell: UITableViewCell {
  
  static let id = "searchCell"
  
  private var indexPath: IndexPath?
  
  var delegate: SearchCellProtocol?
  var task: URLSessionTask?
  
  private let context: NSManagedObjectContext
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    context = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    task?.cancel()
    imageView?.image = nil
    textLabel?.text = nil
    indexPath = nil
  }
}

extension SearchCell {
  func configure(model data: ModelData, indexPath: IndexPath) {
    self.indexPath = indexPath
    switch(data) {
    case .some(let model):
      
//      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Photo.entity().name!)
//      fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: model.id))
//      
//      let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (asynchronousFetchResult) -> Void in
//        if let obj = (asynchronousFetchResult.finalResult as? [NSManagedObject])?.first {
//          let id = obj.value(forKey: #keyPath(Photo.id))! as! Int
//          let photo = obj.value(forKey: #keyPath(Photo.photo)) as! Data
//        } else {
//          
//        }
//      }
//      
//      do {
//        try context.execute(asynchronousFetchRequest)
//      } catch {
//        let fetchError = error as NSError
//        print("\(fetchError), \(fetchError.userInfo)")
//      }
      
      task = UIImageView.load(urlString: model.imageUrl, completion: { [weak self] result in
        guard let self = self else {
          return
        }
        switch result {
        case .success(let data):
          DispatchQueue.main.async { [weak self] in
            guard let self = self else {
              return
            }
            self.imageView?.image = UIImage(data: data)
            self.setNeedsLayout()
          }
        case .failure(let error):
          print(error.localizedDescription)
        }
      })
      task?.resume()
      textLabel?.text = model.tags
    default:
      textLabel?.text = "..."
      self.imageView?.image = nil
    }
  }
  
  enum ModelData {
    case none
    case some(model: SearchModel)
  }
}
