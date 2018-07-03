//
//  CoreDataHelper.swift
//  NotesCoreData_RestApi
//
//  Created by Oleg Granchenko on 7/2/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func note(with id: String) -> Note? {
        let listNotes = retrieveNotes()
        return listNotes.filter({$0.id == id}).first
    }
    
    static func newNote() -> Note {
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        
        return note
    }
    
    static func saveNote() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func delete(note: Note) {
        context.delete(note)
        
        saveNote()
    }
    
    static func retrieveNotes() -> [Note] {
        do {
            let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
}



