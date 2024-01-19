//
//  ItemModel.swift
//  kidsnote
//
//  Created by Hyeonjoon Kim_M1 on 2024/01/17.
//

import Foundation

struct ItemModel: Decodable, Hashable {
    
    var kind: String?
    var id: String?
    var etag: String?
    var selfLink: String?
    var volumeInfo: VolumeInfo?
    var saleInfo: SaleInfo?
    var accessInfo: AccessInfo?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(kind)
        hasher.combine(id)
    }
    
    static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
        return lhs.kind == rhs.kind && lhs.id == rhs.id
    }
}

// Volume Info
struct VolumeInfo: Decodable {
    var title: String?
    var authors: [String]?
    var publishedDate: String?
    var industryIdentifiers: [IndustryIdentifier]?
    var readingModes: ReadingMode?
    var pageCount: Int?
    var printType: String?
    var categories: [String]?
    var maturityRating: String?
    var allowAnonLogging: Bool?
    var contentVersion: String?
    var imageLinks: ImageLink?
    var language: String?
    var previewLink: String?
    var infoLink: String?
    var canonicalVolumeLink: String?
}

struct IndustryIdentifier: Decodable {
    var type: String?
    var identifier: String?
}
struct ReadingMode: Decodable {
    var text: Bool?
    var image: Bool?
}
struct ImageLink: Decodable {
    var smallThumbnail: String?
    var thumbnail: String?
}


// Sale Info
struct SaleInfo: Decodable {
    var country: String?
    var saleability: String?
    var isEbook: Bool?
}


// Access Info
struct AccessInfo: Decodable {
    var country: String?
    var viewability: String?
    var embeddable: Bool?
    var publicDomain: Bool?
    var textToSpeechPermission: String?
    var epub: Epub?
    var pdf: Pdf?
    var webReaderLink: String?
    var accessViewStatus: String?
    var quoteSharingAllowed: Bool?
}

struct Epub: Decodable {
    var isAvailable: Bool?
}
struct Pdf: Decodable {
    var isAvailable: Bool?
}
