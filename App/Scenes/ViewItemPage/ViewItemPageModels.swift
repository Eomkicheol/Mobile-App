//
//  ViewItemPageModels.swift
//  App
//
//  Created by Schön, Ralph on 13.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

import UIKit

// MARK: Request Models

struct ViewItemRequestModel {
    let uri: String
    let indexPath: IndexPath
}

// MARK: Response Models

struct ViewItemPageResponseModel {
    let sourceURIs: [String]
}

struct ViewItemResponseModel {
    let sourceURI: String
    let image: UIImage?
}

// MARK: View Models

struct ViewItemPageViewModel {
    var sections: [ViewItemPageSection]
}

struct ViewItemPageSection {
    var rows: [ViewItemPageRow]
}

enum ViewItemPageRowState {
    case new, downloaded, failed
}

struct ViewItemPageRow {
    let sourceURI: String
    let state: ViewItemPageRowState
    let image: UIImage?

    init(sourceURI: String, state: ViewItemPageRowState = ViewItemPageRowState.new, image: UIImage? = R.image.placeholder()) {
        self.sourceURI = sourceURI
        self.state = state
        self.image = image
    }
}

extension ViewItemPageViewModel: Equatable {
    static func == (lhs: ViewItemPageViewModel, rhs: ViewItemPageViewModel) -> Bool {
        return lhs.sections == rhs.sections
    }
}

extension ViewItemPageSection: Equatable {
    static func == (lhs: ViewItemPageSection, rhs: ViewItemPageSection) -> Bool {
        return lhs.rows == rhs.rows
    }
}

extension ViewItemPageRow: Equatable {
    static func == (lhs: ViewItemPageRow, rhs: ViewItemPageRow) -> Bool {
        return lhs.sourceURI == rhs.sourceURI &&
            lhs.state == rhs.state &&
            lhs.image == rhs.image
    }
}
