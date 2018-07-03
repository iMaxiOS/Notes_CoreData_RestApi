//
//  DisplayNoteViewController.swift
//  NotesCoreData_RestApi
//
//  Created by Oleg Granchenko on 7/2/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import UIKit

class ListNotesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var modifiedTimeStampLabel: UILabel!
    
    override func awakeFromNib() {
        LanguageManager.notifier.subscribe(self) { [unowned self] (_, languageManager) in
            self.idLabel.text = self.idLabel.text?.localized(for: languageManager.bundle)
            self.informationLabel.text = self.informationLabel.text?.localized(for: languageManager.bundle)
            self.modifiedTimeStampLabel.text = self.modifiedTimeStampLabel.text?.localized(for: languageManager.bundle)
        }
    }
}
