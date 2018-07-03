//
//  String+HTMLStringConversion.swift
//  ProductBrowser
//
//  Created by Prajakta Kulkarni on 03/07/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    func isHTML() -> Bool {
       let range =  self.range(of: "<[^>]+>", options: .regularExpression, range: nil, locale: nil)
        return range != nil
    }
}
