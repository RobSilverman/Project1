//
//  Picture.swift
//  Project1
//
//  Created by Robert Silverman on 6/22/20.
//  Copyright © 2020 Robert Silverman. All rights reserved.
//

import UIKit

class Picture: NSObject, Codable {
    
    var fileName: String
    var lookCount: Int
    
    init(name: String) {
        self.fileName = name
        self.lookCount = 0
        super.init()
    }

}
