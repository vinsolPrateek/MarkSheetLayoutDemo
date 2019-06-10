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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerSupplimentaryViews()
    }
    
    private func registerSupplimentaryViews() {
        func registerReusableView(ofType type: HeaderSupplementaryViewProtocol.Type) {
            let nib = UINib(nibName: type.identifier, bundle: nil)
            collectionView.register(nib, forSupplementaryViewOfKind: type.identifier, withReuseIdentifier: type.reuseIdentifier)
        }
        registerReusableView(ofType: RowHeaderSupplementaryView.self)
        registerReusableView(ofType: ColumnHeaderSupplementaryView.self)
    }
    
    private func subject(atColumn columnIndex: Int) -> Subject {
        return Subject.allCases[columnIndex]
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return students.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Subject.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarksCollectionViewCell.identifier, for: indexPath) as! MarksCollectionViewCell
        let userMarks = students[indexPath.section].marks[subject(atColumn: indexPath.item)] ?? 0
        cell.setupCell(userMarks: userMarks, outOf: Consts.maximumAllotedMarks)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewType: HeaderSupplementaryViewProtocol.Type
        let title: String
        if kind == RowHeaderSupplementaryView.identifier {
            headerViewType = RowHeaderSupplementaryView.self
            title = students[indexPath.section].name
        } else if kind == ColumnHeaderSupplementaryView.identifier {
            headerViewType = ColumnHeaderSupplementaryView.self
            title = subject(atColumn: indexPath.item).title
        } else {
            return UICollectionReusableView()
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: headerViewType.identifier, withReuseIdentifier: headerViewType.reuseIdentifier, for: indexPath) as! HeaderSupplementaryView
        headerView.setTitle(title)
        return headerView
    }
}

