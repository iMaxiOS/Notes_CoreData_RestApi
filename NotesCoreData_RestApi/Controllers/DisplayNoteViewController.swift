//
//  DisplayNoteViewController.swift
//  NotesCoreData_RestApi
//
//  Created by iMaxiOS on 7/2/18.
//  Copyright © 2018 Maxim Granchenko. All rights reserved.
//


import UIKit

class DisplayNoteViewController : UIViewController {
    
    var note: Note?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let note = note {
            titleTextField.text = note.title
            contentTextView.text = note.content
        } else {
            titleTextField.text = ""
            contentTextView.text = ""
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier,
            let destination = segue.destination as? ListNotesTableViewController
            else { return }
        
        switch identifier {
            
        case "save" where note != nil:
            note?.title = titleTextField.text ?? ""
            note?.content = contentTextView.text ?? ""
            
            destination.tableView.reloadData()
            
        case "save" where note == nil:
            let note = Note()
            note.title = titleTextField.text ?? ""
            note.content = contentTextView.text ?? ""
            note.modificationTime = Date()
            
            destination.notes.append(note)
            
        case "cancel":
            print("cancel bar button item tapped")
            
        default:
            print("unexpected segue identifier")
        }
    }
    
    @IBAction func save(_segue: UIStoryboardSegue) {
        
    }
    
}
