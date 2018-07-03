//
//  ListNotesTableViewController.swift
//  NotesCoreData_RestApi
//
//  Created by Oleg Granchenko on 7/2/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import UIKit
import CoreData

class ListNotesTableViewController: UITableViewController {
    
    var notes = [Note]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let _notes = CoreDataHelper.retrieveNotes()
        if _notes.isEmpty {
            PersistencyManager.shared.getAllNotes { [unowned self] in
                DispatchQueue.main.async {
                    self.notes = CoreDataHelper.retrieveNotes()
                }
            }
        } else {
            notes = _notes
        }
    }
    
    @IBAction func unwind(_segue: UIStoryboardSegue) {
        notes = CoreDataHelper.retrieveNotes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "displayNote":
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let note = notes[indexPath.row]
            let destination = segue.destination as! DisplayNoteViewController
            destination.note = note
            
        case "addNote":
            print("Create note bar button item tapped")
        default:
            print("Unexpected segue identifier")
        }
    }
    
    @IBAction func addNode() {
        PersistencyManager.shared.addNode(title: "", info: "", completion: {
            DispatchQueue.main.async {
                self.notes = CoreDataHelper.retrieveNotes()
            }
        })
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! ListNotesTableViewCell

       let note = notes[indexPath.row]
        cell.idLabel.text = note.id
        cell.informationLabel.text = note.content
        cell.modifiedTimeStampLabel.text = note.modificationTime?.convertToString() ?? "unknown"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteToDelete = notes[indexPath.row]
            PersistencyManager.shared.deleteNode(note: noteToDelete) { [unowned self] in
                DispatchQueue.main.async {
                    self.notes = CoreDataHelper.retrieveNotes()
                }
            }
        }
    }
}
