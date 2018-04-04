//
//  CustomMigrationPolicy.swift
//  Companies
//
//  Created by Jeff Kral on 12/29/17.
//  Copyright © 2017 Jeff Kral. All rights reserved.
//

import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
    
    @objc func transformNumEmployees(forNum: NSNumber) -> String {
        if forNum.intValue < 150 {
            return "small"
        } else {
            return "large"
        }
    }
    
}
