//
//  ItemImageDTO.swift
//  App
//
//  Created by Schön, Ralph on 17.06.19.
//  Copyright © 2019 Schön, Ralph. All rights reserved.
//

struct ItemImageDTO: Decodable {
    let uri: String
}

extension ItemImageDTO: Equatable {
    static func == (lhs: ItemImageDTO, rhs: ItemImageDTO) -> Bool {
        return lhs.uri == rhs.uri
    }
}
