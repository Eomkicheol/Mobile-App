//
//  ViewItemPageDataSource.swift
//  App
//
//  Created by Schön, Ralph on 21.06.19.
//  Copyright © 2019 Schön, Ralph. All rights reserved.
//

import UIKit

protocol ViewItemPageCollectionDelegate: class {
    func getItemThumbnail(with details: ViewItemRequestModel)
}

class ViewItemPageDataSource: NSObject, UICollectionViewDataSource {
    var dataStore: ViewItemPageViewModel?
    weak var delegate: ViewItemPageCollectionDelegate?

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataStore?.sections.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataStore?.sections[section].rows.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.itemCell, for: indexPath) else {
            fatalError("Failed to get registered cell of type ItemCell")
        }
        guard let item = dataStore?.sections[indexPath.section].rows[indexPath.row] else {
            return cell
        }
        cell.imageView.image = item.image

        switch item.state {
        case .failed:
            cell.imageView.image = R.image.placeholder()
        case .new:
            let requestModel = ViewItemRequestModel(uri: item.sourceURI, indexPath: indexPath)
            delegate?.getItemThumbnail(with: requestModel)
        case .downloaded:
            break // thumbnail is already in dataSource
        }
        return cell
    }
}
