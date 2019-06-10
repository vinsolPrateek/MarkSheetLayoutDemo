//
//  MarkSheetCollectionViewLayout.swift
//  ScoreSheet
//
//  Created by Prateek Sharma on 11/21/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class MarkSheetCollectionViewLayout: UICollectionViewLayout {

    private enum Consts {
        static let rowHeaderWidth: CGFloat = 100
        static let oneRowHeight: CGFloat = 50
        static let columnHeaderHeight: CGFloat = 40
    }
    
    private var numberOfColumns: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
    private var numberOfRows: Int {
        return collectionView!.numberOfSections
    }
    private var columnWidth: CGFloat {
        let contentWidth = collectionViewContentSize.width - Consts.rowHeaderWidth
        return (contentWidth / CGFloat(numberOfColumns))
    }
    
    override var collectionViewContentSize: CGSize {
        let contentHght = Consts.columnHeaderHeight + Consts.oneRowHeight * CGFloat(numberOfRows)
        return CGSize(width: collectionView?.bounds.width ?? 0, height: contentHght)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return collectionView?.bounds.width != newBounds.width
    }
}
    
extension MarkSheetCollectionViewLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        layoutAttributes.append(contentsOf: createLayoutAttributesForItems(in: rect))
        layoutAttributes.append(contentsOf: createLayoutAttributesForHeaders(in: rect))
        
        return layoutAttributes
    }
    
    private func columnIndex(at xPosition: CGFloat) -> Int {
        let index = max(0, Int((xPosition - Consts.rowHeaderWidth) / columnWidth))
        return min(index, numberOfColumns - 1)
    }
    
    private func rowIndex(at yPosition: CGFloat) -> Int {
        let hourIndex = max(0, Int((yPosition - Consts.columnHeaderHeight) / Consts.oneRowHeight))
        return min(hourIndex, numberOfRows - 1)
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
        frame.origin.x = Consts.rowHeaderWidth + cellWidth * CGFloat(column)
        frame.origin.y = Consts.columnHeaderHeight + Consts.oneRowHeight * CGFloat(row)
        frame.size = CGSize(width: cellWidth, height: Consts.oneRowHeight)
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
        
        let columnHeaderAttributes = createLayoutAttributes(forHeaderType: ColumnHeaderSupplementaryView.self, visibleIndexPaths: indexPathsForColumnHeaderViews(in: rect))
        let rowHeaderAttributes = createLayoutAttributes(forHeaderType: RowHeaderSupplementaryView.self, visibleIndexPaths: indexPathsForRowHeaderViews(in: rect))
        return columnHeaderAttributes + rowHeaderAttributes
    }
    
    private func indexPathsForRowHeaderViews(in rect: CGRect) -> [IndexPath] {
        guard rect.minX <= Consts.rowHeaderWidth  else { return [] }
        let startRowIndex = rowIndex(at: rect.minY)
        let endRowIndex = rowIndex(at: rect.maxY)
        
        var indexPaths = [IndexPath]()
        for i in startRowIndex...endRowIndex {
            indexPaths.append(IndexPath(item: 0, section: i))
        }
        return indexPaths
    }
    
    private func indexPathsForColumnHeaderViews(in rect: CGRect) -> [IndexPath] {
        guard rect.minY <= Consts.columnHeaderHeight  else { return [] }
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
            let xPosition = Consts.rowHeaderWidth + (cellWidth * CGFloat(indexPath.item))
            layoutAttributes.frame = CGRect(x: xPosition, y: 0, width: cellWidth, height: Consts.columnHeaderHeight)
        } else if elementKind == RowHeaderSupplementaryView.identifier {
            let yPosition = Consts.columnHeaderHeight + (Consts.oneRowHeight * CGFloat(indexPath.section))
            layoutAttributes.frame = CGRect(x: 0, y: yPosition, width: Consts.rowHeaderWidth, height: Consts.oneRowHeight)
        }
        
        return layoutAttributes
    }
    
}
