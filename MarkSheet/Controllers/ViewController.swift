//
//  ViewController.swift
//  MarkSheet
//
//  Created by Prateek Sharma on 6/10/19.
//  Copyright © 2019 Prateek Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private enum Consts {
        static let maximumAllotedMarks: Double = 100
    }
    private var students: [Student] = {
        let names = ["Kal El", "Natasha", "Gangadhar", "Wilson", "Barton", "Stark", "Talia", "Thor", "Trevor", "Bruce", "Diana", "Allen", "Thawne", "Arthur", "Fury"]
        return names.map {
            let marks = Subject.allCases.reduce([Subject: Double](), { (dict: [Subject: Double], subject) -> [Subject: Double] in
                return dict.join(dict: [subject: Double(arc4random_uniform(UInt32(Consts.maximumAllotedMarks)) + 1)])
            })
            return Student(name: $0, marks: marks)
        }
    }()

    @IBOutlet weak private var collectionView: UICollectionView!
    
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return students.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Subject.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}

