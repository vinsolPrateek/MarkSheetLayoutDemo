//
//  Subject.swift
//  ScoreSheet
//
//  Created by Prateek Sharma on 6/4/19.
//  Copyright © 2019 Prateek Sharma. All rights reserved.
//

import Foundation

enum Subject: String, CaseIterable {
    case maths, physics
    
    var title: String { return rawValue.uppercased() }
}
