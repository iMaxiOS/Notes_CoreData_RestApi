//
//  String+Ext.swift
//  NotesCoreData_RestApi
//
//  Created by Oleg Granchenko on 7/2/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import Foundation

extension String {
    
    func localized(for bundle: Bundle) -> String {
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
