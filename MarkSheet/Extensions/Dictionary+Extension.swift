//
//  Dictionary.swift
//  ScoreSheet
//
//  Created by Prateek Sharma on 6/4/19.
//  Copyright © 2019 Prateek Sharma. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func join(dict: [Key: Value]) -> [Key: Value] {
        var newDict = self
        for (key, value) in dict {
            newDict[key] = value
        }
        return newDict
    }
    
}
