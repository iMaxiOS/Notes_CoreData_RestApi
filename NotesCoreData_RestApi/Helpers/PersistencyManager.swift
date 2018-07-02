//
//  PersistencyManager.swift
//  NotesCoreData_RestApi
//
//  Created by Oleg Granchenko on 7/2/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import UIKit
import CoreData

//Facade pattern

class PersistencyManager {
    static let shared = PersistencyManager()
    
    func getAllNotes(completion: @escaping ()->()) {
        APIManager.shared.getAllNotes { data in
            guard let notes = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            if let notesList = notes as? Array<Dictionary<String, Any>> {
                for note in notesList {
                    let _note = CoreDataHelper.newNote()
                    _note.id = "\(note["id"] as? Int ?? -1)"
                    _note.content = note["title"] as? String ?? ""
                    CoreDataHelper.saveNote()
                }
                completion()
            }
        }
    }
    
    func addNode(title: String, info: String,completion: @escaping ()->()) {
        APIManager.shared.createNote(title: title, info: info, complition: { data in
            guard let notes = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            if let note = notes as? Dictionary<String, Any> {
                let _note = CoreDataHelper.newNote()
                _note.id = "\(note["id"] as? Int ?? -1)"
                _note.content = note["title"] as? String ?? ""
                CoreDataHelper.saveNote()
                completion()
            }
        })
    }
    
    func updateNode(with id: String, completion: (()->())?) {
        APIManager.shared.updateNote(with: id) { data in
            guard let notes = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            if let note = notes as? Dictionary<String, Any> {
                let _note = CoreDataHelper.newNote()
                _note.id = "\(note["id"] as? Int ?? -1)"
                _note.content = note["title"] as? String ?? ""
                CoreDataHelper.saveNote()
                completion?()
            }
        }
        
    }
    
    func deleteNode(note: Note, completion: @escaping ()->()) {
        APIManager.shared.deleteNote(with: (note.id ?? "-1"), completion: {
            CoreDataHelper.delete(note: note)
            completion()
        })
    }
}
