//
//  RowHeaderSupplementaryView.swift
//  ScoreSheet
//
//  Created by Prateek Sharma on 11/21/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class RowHeaderSupplementaryView: HeaderSupplementaryView {

    static let identifier = "RowHeaderSupplementaryView"
    static let reuseIdentifier = "rowHeaderCRView"
    
    @IBOutlet weak private var titleLbl: UILabel!
    
    func setTitle(_ title: String) {
        titleLbl.text = title
    }
}
