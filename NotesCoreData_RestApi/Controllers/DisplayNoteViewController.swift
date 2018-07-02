//
//  DisplayNoteViewController.swift
//  NotesCoreData_RestApi
//
//  Created by iMaxiOS on 7/2/18.
//  Copyright © 2018 Maxim Granchenko. All rights reserved.
//


import UIKit

class DisplayNoteViewController : UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleTextField.text = ""
        contentTextView.text = ""
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "save":
            let note = Note()
            note.title = titleTextField.text ?? ""
            note.content = contentTextView.text ?? ""
            note.modificationTime = Date()
            
            let destination = segue.destination as! ListNotesTableViewController
            destination.notes.append(note)
            
        case "cancel":
            print("Cancel bar button item tapped")
            
        default:
            print("Unexpected segue identifier")
        }
    }
    
    @IBAction func save(_segue: UIStoryboardSegue) {
        
    }
    
}
