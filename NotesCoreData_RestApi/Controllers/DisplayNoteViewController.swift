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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(param:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(param:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        contentTextView.layer.cornerRadius = 7
        
        if let note = note {
            titleTextField.text = note.title
            contentTextView.text = note.content
        } else {
            titleTextField.text = ""
            contentTextView.text = ""
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentTextView.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "save" where note != nil:
            note?.title = titleTextField.text ?? ""
            note?.content = contentTextView.text ?? ""
            note?.modificationTime = Date()
            
            CoreDataHelper.saveNote()
            
        case "save" where note == nil:
            let note = CoreDataHelper.newNote()
            note.title = titleTextField.text ?? ""
            note.content = contentTextView.text ?? ""
            note.modificationTime = Date()
            
            CoreDataHelper.saveNote()
            
        case "cancel":
            print("cancel bar button item tapped")
            
        default:
            print("unexpected segue identifier")
        }
    }
    
    @objc func updateTextView(param: Notification) {
        let userInfo = param.userInfo
        
        let getKeyBouarRect = (userInfo![UIKeyboardFrameEndUserInfoKey] as!NSValue).cgRectValue
        let keyBoardFrame = self.view.convert(getKeyBouarRect, to: view.window)
        if param.name == Notification.Name.UIKeyboardWillHide {
            contentTextView.contentInset = UIEdgeInsets.zero
        } else {
            contentTextView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardFrame.height, 0)
            contentTextView.scrollRangeToVisible(contentTextView.selectedRange)
        }
    }
    
    @IBAction func save(_segue: UIStoryboardSegue) {
        
    }
    
}
