//
//  SearchModel.swift
//  kidsnote
//
//  Created by Hyeonjoon Kim_M1 on 2024/01/17.
//

import Foundation

struct SearchListModel: Decodable {
    var kind: String?
    var totalItems: Int?
    var items: [ItemModel]?
}



