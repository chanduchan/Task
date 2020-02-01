//
//  Services.swift
//  FrostAssignment
//
//  Created by Chandrasekhar K on 31/01/20.
//  Copyright © 2020 Chandrasekhar K. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum Result<T> {
    case success(T)
    case failure(Error)
}

struct CoreDataRepository {
    
    // MARK: - Read coredata
    func getNotesList(completion: @escaping (Result<[NSManagedObject]>) -> Void) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Notes")
        do {
            let result = try managedContext.fetch(fetchRequest)
            completion(.success(result))
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completion(.failure(error))
        }
    }
    
    // MARK: - create Coredata
    func saveNotes(title name: String, desctiption desc:String,imgData:Data?){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let note = Notes(context: managedContext)
        note.title = name
        note.descriptions = desc
        note.date = Date()
        if imgData != nil{
            note.image = imgData
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Delete coredata
    func deleteNotes(_ name: NSManagedObject, completion: @escaping (Result<[NSManagedObject]>) -> Void){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Notes")
        managedContext.delete(name)
        do {
            try managedContext.save()
            let result = try managedContext.fetch(fetchRequest)
            completion(.success(result))
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(.failure(error))
        }
    }
    
    // MARK: - Search Coredata
    func searchNotesList(_ searchText:String, completion: @escaping (Result<[NSManagedObject]>) -> Void) {
        
        var predicate: NSPredicate = NSPredicate()
        predicate = NSPredicate(format: "title contains[c] '\(searchText)' || descriptions contains[c] '\(searchText)'")        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Notes")
        fetchRequest.predicate = predicate
        do {
            let result = try managedContext.fetch(fetchRequest)
            completion(.success(result))
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completion(.failure(error))
        }
    }
    
     // MARK: - Sort By Date&&Name Coredata
    func sortlistDate(key:String,isAscending:Bool, completion: @escaping (Result<[NSManagedObject]>) -> Void){
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
       
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Notes")
        let sort = NSSortDescriptor(key: key, ascending: isAscending)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let  result = try managedContext.fetch(fetchRequest)
            completion(.success(result))
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completion(.failure(error))
        }
    }
    
   
}
