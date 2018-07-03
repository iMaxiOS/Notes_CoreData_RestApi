//
//  LanguageManager
//  NotesCoreData_RestApi
//
//  Created by Oleg Granchenko on 7/2/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import Foundation

class LanguageManager {
    
    static let sharedInstance = LanguageManager()
    static let notifier = BlockNotifier<LanguageManager>()
    
    init() {
        let deviceLocale = String(Locale.preferredLanguages[0].prefix(2))
        if !deviceLocale.isEmpty {
            locale = deviceLocale
        }
    }
    
    var locale: String = "en" {
        willSet { LanguageManager.notifier.notify(self) }
    }
    
    var bundle: Bundle {
        return Bundle(path: Bundle.main.path(forResource: locale, ofType: "lproj") ?? "") ?? Bundle.main
    }
}

