//
//  ColumnHeaderSupplementaryView.swift
//  ScoreSheet
//
//  Created by Prateek Sharma on 11/21/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class ColumnHeaderSupplementaryView: HeaderSupplementaryView {

    static let identifier = "ColumnHeaderSupplementaryView"
    static let reuseIdentifier = "columnHeaderCRView"
    
    @IBOutlet weak private var titleLbl: UILabel!
    
    func setTitle(_ title: String) {
        titleLbl.text = title
    }
}
