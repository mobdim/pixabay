//
//  CoreDataHelper.swift
//  pixabay
//
//  Created by Dmitriy Zadoroghnyy on 03/04/2019.
//  Copyright © 2019 Dmitriy Zadoroghnyy. All rights reserved.
//

import UIKit
import CoreData

func getViewContext() -> NSManagedObjectContext? {
  return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
}

func saveContext() {
  (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
}
