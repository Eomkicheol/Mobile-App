//
//  ItemPageDTO.swift
//  App
//
//  Created by Schön, Ralph on 17.06.19.
//  Copyright © 2019 Schön, Ralph. All rights reserved.
//

struct ItemPageDTO: Decodable {
    let images: [ItemImageDTO]
}

extension ItemPageDTO: Equatable {
    static func == (lhs: ItemPageDTO, rhs: ItemPageDTO) -> Bool {
        return lhs.images == rhs.images
    }
}
