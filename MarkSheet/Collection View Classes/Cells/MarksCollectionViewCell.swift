//
//  MarksCollectionViewCell.swift
//  ScoreSheet
//
//  Created by Prateek Sharma on 11/21/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class MarksCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "marksCell"
    
    @IBOutlet weak private var marksLabel: UILabel!

    func setup(userMarks: Double, outOf totalMarks: Double) {
        marksLabel.text = String(format: "%.2f / %.2f", userMarks, totalMarks)
    }
}
