//
//  ListNotesTableViewController.swift
//  NotesCoreData_RestApi
//
//  Created by iMaxiOS on 7/2/18.
//  Copyright © 2018 Maxim Granchenko. All rights reserved.
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
    
    @IBAction func unwind(_segue: UIStoryboardSegue) {
        notes = CoreDataHelper.retrieveNotes()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! ListNotesTableViewCell

       let note = notes[indexPath.row]
        cell.informationLabel.text = note.title
        cell.modifiedTimeStampLabel.text = note.modificationTime?.convertToString() ?? "unknown"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteToDelete = notes[indexPath.row]
            CoreDataHelper.delete(note: noteToDelete)
            
            notes = CoreDataHelper.retrieveNotes()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
 
}
