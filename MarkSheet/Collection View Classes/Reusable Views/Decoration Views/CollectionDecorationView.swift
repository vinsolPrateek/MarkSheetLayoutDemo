//
//  CollectionDecorationView.swift
//  MarkSheet
//
//  Created by Prateek Sharma on 6/19/19.
//  Copyright © 2019 Prateek Sharma. All rights reserved.
//

import UIKit

class CollectionDecorationView: UICollectionReusableView, CollectionReusableViewProtocol {
    static var identifier = "CollectionDecorationView"
    static var reuseIdentifier = "decorationView"
    
    override var reuseIdentifier: String? {
        return CollectionDecorationView.reuseIdentifier
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        customInit()
    }
    
    func customInit() {
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
}
