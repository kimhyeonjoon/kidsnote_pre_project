//
//  ItemModel.swift
//  kidsnote
//
//  Created by Hyeonjoon Kim_M1 on 2024/01/17.
//

import Foundation
import UIKit

struct ItemModel: Decodable, Hashable {
    
    var kind: String?
    var id: String?
    var etag: String?
    var selfLink: String?
    var volumeInfo: VolumeInfo?
    var layerInfo: LayerInfo?
    var saleInfo: SaleInfo?
    var accessInfo: AccessInfo?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(kind)
        hasher.combine(id)
    }
    
    static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
        return lhs.kind == rhs.kind && lhs.id == rhs.id
    }
    
    
    // title
    func titleText() -> String? {
        guard let title = volumeInfo?.title else {
            return nil
        }
        
        if let subTitle = volumeInfo?.subtitle {
            return "\(title): \(subTitle)"
        }
        
        return title
    }
    
    // authos
    func authosText() -> String? {
        
        guard let authors = volumeInfo?.authors else {
            return nil
        }
        
        if authors.count == 1 {
            return authors.first
        } else if authors.count == 2 {
            return authors.joined(separator: " 및 ")
        } else {
            return authors.joined(separator: ", ")
        }
    }
    
    // ebook
    func eBookAveText() -> String? {
        guard let isEBook = saleInfo?.isEbook, let aver = volumeInfo?.averageRating else {
            return nil
        }
        
        guard isEBook == true else {
            return nil
        }
        
        return "eBook \(aver)★"
    }
    
    // html description
    func descriptionText() -> NSAttributedString? {
        
        let font = UIFont.systemFont(ofSize: 14)
        if let hex = grayColor.hexString {
            return volumeInfo?.description?.htmlText(hexString: hex, font: font)
        }
        
        return nil
    }
}

// Volume Info
struct VolumeInfo: Decodable {
    var title: String?
    var subtitle: String?
    var authors: [String]?
    var publisher: String?
    var publishedDate: String?
    var description: String?
    var industryIdentifiers: [IndustryIdentifier]?
    var readingModes: ReadingMode?
    var pageCount: Int?
    var printedPageCount: Int?
    var printType: String?
    var categories: [String]?
    var averageRating: Double?
    var ratingsCount: Int?
    var maturityRating: String?
    var allowAnonLogging: Bool?
    var contentVersion: String?
    var panelizationSummary: PanelizationSummary?
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
struct PanelizationSummary: Decodable {
    var containsEpubBubbles: Bool?
    var containsImageBubbles: Bool?
}
struct ImageLink: Decodable {
    var smallThumbnail: String?
    var thumbnail: String?
    var small: String?
    var medium: String?
    var large: String?
    var extraLarge: String?
    
    func url() -> String? {
        return thumbnail ?? smallThumbnail ?? small ?? medium ?? large ?? extraLarge
    }
}

// Layar Info
struct LayerInfo: Decodable {
    struct Layer: Decodable {
        var layerId: String?
        var volumeAnnotationsVersion: String?
    }
    var layers: [Layer]?
}


// Sale Info
struct SaleInfo: Decodable {
    var country: String?
    var saleability: String?
    var isEbook: Bool?
    var listPrice: PriceInfo?
    var retailPrice: PriceInfo?
    var buyLink: String?
    var offers: [Offer]?
}
struct PriceInfo : Decodable {
    var amount: Int?
    var currencyCode: String?
}
struct Offer: Decodable {
    var finskyOfferType: Int?
    var listPrice: PriceInfo?
    var retailPrice: PriceInfo?
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
