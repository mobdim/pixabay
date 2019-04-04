//
//  SearchInteractor.swift
//  pixabay
//
//  Created by mobdim on 01/04/2019.
//  Copyright © 2019 pixabay. All rights reserved.
//

import Foundation
import CoreData

class SearchInteractor {
  let presenter: SearchInteractorOutput
    
  init(presenter: SearchInteractorOutput) {
    self.presenter = presenter
  }
}

// MARK: - SearchInteractorInput

extension SearchInteractor: SearchInteractorInput {
  func search(text: String, page: Int, per_page: Int) {
    let urlString = "https://pixabay.com/api/?key=12057211-da8b15ee83b85dc84156454c8&q=\(text)&image_type=photo&pretty=true&page=\(page)&per_page=\(per_page)"
    
    print("search: \(urlString)")
    
    guard let url = URL(string: urlString) else {
      presenter.didSearchFailure(message: "invalid URL")
      return
    }
    let urlRequest = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, _, error) in
      
      guard let self = self else {
        return
      }
      
      if error != nil {
        self.presenter.didSearchFailure(message: "request fail")
        return
      }
      do {
        let jsonObj = try JSONSerialization.jsonObject(with: data!)
        guard let json = jsonObj as? [String: AnyObject], let data = json["hits"] as? [[String: AnyObject]] else {
          self.presenter.didSearchFailure(message: "json error!")
          return
        }
        DispatchQueue.main.async {
          self.updateDB(json: data)
          self.presenter.didSearchSuccess()
        }
      } catch {
        self.presenter.didSearchFailure(message: "fail to parse json!")
      }

    }
    task.resume()
  }
  
  func clearDB() {    
    guard let context = getViewContext() else { return }
    
    let entity_name = Photo.entity().name!
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_name)
    fetchRequest.returnsObjectsAsFaults = false
    do {
      let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
      _ = objects.map{$0.map{context.delete($0)}}
      saveContext()
      print("DB cleared!")
    } catch let error {
      print("Detele all data in \(entity_name) error :", error)
    }
  }
}

private extension SearchInteractor {
  func updateDB(json: [[String: AnyObject]]) {
    
    _ = json.map{ createPhotoEntityBase(from: $0) }
    do {
      try getViewContext()?.save()
      print("SearchInteractor save success!")
    } catch let error {
      print("SearchInteractor fail save! \(error)")
    }
    
    
    
//    loadPhoto(json: json)
  }
  
  private func createPhotoEntityBase(from dictionary: [String: AnyObject]) -> NSManagedObject? {
    
    guard let context = getViewContext() else { return nil }
    
    if let photoEntity = NSEntityDescription.insertNewObject(forEntityName: Photo.entity().name!, into: context) as? Photo {
      photoEntity.id = (dictionary["id"] as? Int64)!
      photoEntity.tags = dictionary["tags"] as? String
      photoEntity.largeImageURL = dictionary["largeImageURL"] as? String
      photoEntity.createdAt = Date() as NSDate
//      print("add: \(photoEntity.id) \(photoEntity.tags) \(photoEntity.createdAt)")
      return photoEntity
    }
    return nil
  }
  
  private func loadPhoto(json: [[String: AnyObject]]) {
    guard let context = getViewContext() else { return }
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Photo.entity().name!)
    
    _ = json.map { dictionary in
      let id = dictionary["id"] as! Int64
      let imageUrl = dictionary["largeImageURL"] as! String
      fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
      do {
        let res = try context.fetch(fetchRequest)
        if let obj = res.first as? NSManagedObject {
          let task = load(urlString: imageUrl, completion: { result in
            switch result {
            case .success(let data):
              DispatchQueue.main.async {
                obj.setValue(data, forKey: #keyPath(Photo.photo))
                do {
                  try context.save()
                  print("save image \(id) \(data)")
                }
                catch {
                  print(error)
                }
              }
            case .failure(let error):
              print(error.localizedDescription)
            }
          })
          task?.resume()
        }
      }
      catch {
        print("error pic: \(id)")
      }
    }
    
  }
}
