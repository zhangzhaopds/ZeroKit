//
//  UICollectionView+ZeroExtension.swift
//  ZeroKit
//
//  Created by zhangzhao on 2022/6/22.
//

import UIKit

public extension UICollectionView {
    
    public func registerCell<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: "\(T.self)")
    }
    
    public func registerHeader<T: UICollectionReusableView>(_ viewClass: T.Type) {
        register(viewClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(T.self)")
    }
    
    public func registerFooter<T: UICollectionReusableView>(_ viewClass: T.Type) {
        register(viewClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "\(T.self)")
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifer = "\(T.self)"
        return dequeueReusableCell(withReuseIdentifier: identifer, for: indexPath) as! T
    }
    
    public func dequeueReusableHeader<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        let identifer = "\(T.self)"
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifer, for: indexPath) as! T
    }
    
    public func dequeueReusableFooter<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        let identifer = "\(T.self)"
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifer, for: indexPath) as! T
    }
    
    public func unreusedCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifier = "\(T.self)\(indexPath)"
        register(T.self, forCellWithReuseIdentifier: identifier)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}
