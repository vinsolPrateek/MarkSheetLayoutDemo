//
//  MarkSheetCollectionViewLayout.swift
//  ScoreSheet
//
//  Created by Prateek Sharma on 11/21/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class MarkSheetCollectionViewLayout: UICollectionViewLayout {

    private enum Constants {
        static let rowHeaderWidth: CGFloat = 100
        static let oneRowHeight: CGFloat = 50
        static let columnHeaderHeight: CGFloat = 40
        static let separatorHeight: CGFloat = 1
    }
    
    private var numberOfColumns: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
    
    private var numberOfRows: Int {
        return collectionView!.numberOfSections
    }
    
    private var columnWidth: CGFloat {
        let contentWidth = collectionViewContentSize.width - Constants.rowHeaderWidth
        return (contentWidth / CGFloat(numberOfColumns))
    }
    
    override var collectionViewContentSize: CGSize {
        let contentHght = Constants.columnHeaderHeight + Constants.oneRowHeight * CGFloat(numberOfRows)
        return CGSize(width: collectionView?.bounds.width ?? 0, height: contentHght)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return collectionView?.bounds.width != newBounds.width
    }
    
    override init() {
        super.init()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        register(CollectionDecorationView.self, forDecorationViewOfKind: CollectionDecorationView.identifier)
    }
}
    
extension MarkSheetCollectionViewLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        layoutAttributes.append(contentsOf: createLayoutAttributesForItems(in: rect))
        layoutAttributes.append(contentsOf: createLayoutAttributesForHeaders(in: rect))
        layoutAttributes.append(contentsOf: createLayoutAttributesForSeparators(in: rect))
        return layoutAttributes
    }
    
    private func columnIndex(at xPosition: CGFloat) -> Int {
        let index = max(0, Int((xPosition - Constants.rowHeaderWidth) / columnWidth))
        return min(index, numberOfColumns - 1)
    }
    
    private func rowIndex(at yPosition: CGFloat) -> Int {
        let index = max(0, Int((yPosition - Constants.columnHeaderHeight) / Constants.oneRowHeight))
        return min(index, numberOfRows - 1)
    }
}

extension MarkSheetCollectionViewLayout {
    
    private func createLayoutAttributesForItems(in rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        let visibleItemsIndexPaths = indexPathsForItems(in: rect)
        visibleItemsIndexPaths.forEach { (indexPath) in
            guard let cellAttribute = layoutAttributesForItem(at: indexPath)  else { return }
            layoutAttributes.append(cellAttribute)
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let cellAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        cellAttribute.frame = frame(forRow: indexPath.section, column: indexPath.item)
        return cellAttribute
    }
    
    private func indexPathsForItems(in rect: CGRect) -> [IndexPath] {
        let startItemRow = rowIndex(at: rect.minY)
        let startItemColumn = columnIndex(at: rect.minX)
        let endItemRow = rowIndex(at: rect.maxY)
        let endItemColumn = columnIndex(at: rect.maxX)
        
        var indexPaths = [IndexPath]()
        for rowIndex in startItemRow...endItemRow {
            for columnIndex in startItemColumn...endItemColumn {
                indexPaths.append(IndexPath(item: columnIndex, section: rowIndex))
            }
        }
        
        return indexPaths
    }
    
    private func frame(forRow row: Int, column: Int) -> CGRect {
        let cellWidth = columnWidth
        var frame = CGRect.zero
        frame.origin.x = Constants.rowHeaderWidth + cellWidth * CGFloat(column)
        frame.origin.y = Constants.columnHeaderHeight + Constants.oneRowHeight * CGFloat(row)
        frame.size = CGSize(width: cellWidth, height: Constants.oneRowHeight)
        return frame
    }

}

extension MarkSheetCollectionViewLayout {
    
    private func createLayoutAttributesForHeaders(in rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        func createLayoutAttributes(forHeaderType headerType: HeaderSupplementaryViewProtocol.Type, visibleIndexPaths: [IndexPath]) -> [UICollectionViewLayoutAttributes] {
            var layoutAttributes = [UICollectionViewLayoutAttributes]()
            visibleIndexPaths.forEach { (indexPath) in
                guard let headerAttribute = layoutAttributesForSupplementaryView(ofKind: headerType.identifier, at: indexPath)
                    else { return }
                layoutAttributes.append(headerAttribute)
            }
            return layoutAttributes
        }
        
        let columnHeaderAttributes = createLayoutAttributes(forHeaderType: ColumnHeaderSupplementaryView.self, visibleIndexPaths: indexPathsForVisibleColumns(in: rect))
        let rowHeaderAttributes = createLayoutAttributes(forHeaderType: RowHeaderSupplementaryView.self, visibleIndexPaths: indexPathsForVisibleRows(in: rect))
        return columnHeaderAttributes + rowHeaderAttributes
    }
    
    private func indexPathsForVisibleRows(in rect: CGRect) -> [IndexPath] {
        guard rect.minX <= Constants.rowHeaderWidth  else { return [] }
        let startRowIndex = rowIndex(at: rect.minY)
        let endRowIndex = rowIndex(at: rect.maxY)
        
        var indexPaths = [IndexPath]()
        for i in startRowIndex...endRowIndex {
            indexPaths.append(IndexPath(item: 0, section: i))
        }
        return indexPaths
    }
    
    private func indexPathsForVisibleColumns(in rect: CGRect) -> [IndexPath] {
        guard rect.minY <= Constants.columnHeaderHeight  else { return [] }
        let startColumnIndex = columnIndex(at: rect.minX)
        let endColumnIndex = columnIndex(at: rect.maxX)
        
        var indexPaths = [IndexPath]()
        for i in startColumnIndex...endColumnIndex {
            indexPaths.append(IndexPath(item: i, section: 0))
        }
        return indexPaths
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        
        if elementKind == ColumnHeaderSupplementaryView.identifier {
            let cellWidth = columnWidth
            let xPosition = Constants.rowHeaderWidth + (cellWidth * CGFloat(indexPath.item))
            layoutAttributes.frame = CGRect(x: xPosition, y: 0, width: cellWidth, height: Constants.columnHeaderHeight)
        } else if elementKind == RowHeaderSupplementaryView.identifier {
            let yPosition = Constants.columnHeaderHeight + (Constants.oneRowHeight * CGFloat(indexPath.section))
            layoutAttributes.frame = CGRect(x: 0, y: yPosition, width: Constants.rowHeaderWidth, height: Constants.oneRowHeight)
        }
        
        return layoutAttributes
    }
    
}

extension MarkSheetCollectionViewLayout {
    
    private func createLayoutAttributesForSeparators(in rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        let visibleIndexPaths = indexPathsForVisibleRows(in: rect)
        visibleIndexPaths.forEach { (indexPath) in
            guard let headerAttribute = layoutAttributesForDecorationView(ofKind: CollectionDecorationView.identifier, at: indexPath)
                else { return }
            layoutAttributes.append(headerAttribute)
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard elementKind == CollectionDecorationView.identifier  else { return nil }
        let layoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
        let yPos = Constants.columnHeaderHeight + (Constants.oneRowHeight * CGFloat(indexPath.section))
        layoutAttributes.frame = CGRect(x: 0, y: yPos, width: collectionViewContentSize.width, height: Constants.separatorHeight)
        layoutAttributes.zIndex = 2
        return layoutAttributes
    }
}
