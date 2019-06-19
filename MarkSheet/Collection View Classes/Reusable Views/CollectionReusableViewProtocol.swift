//
//  HeaderSupplementaryViewProtocol.swift
//  ScoreSheet
//
//  Created by Prateek Sharma on 6/4/19.
//  Copyright © 2019 Prateek Sharma. All rights reserved.
//

import UIKit

protocol CollectionReusableViewProtocol: class {
    static var identifier: String { get }
    static var reuseIdentifier: String { get }
}

protocol HeaderSupplementaryViewProtocol: CollectionReusableViewProtocol {
    func setTitle(_ title: String)
}
typealias HeaderSupplementaryView = UICollectionReusableView & HeaderSupplementaryViewProtocol
