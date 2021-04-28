//
//  Thumbnail.swift
//  Marvel Heroes
//
//  Created by César Ferreira on 24/04/21.
//

import Foundation

struct Thumbnail: Codable {

    let path: String?
    let extensionThumbnail: String?

    enum CodingKeys: String, CodingKey {
        case path
        case extensionThumbnail = "extension"
    }
}
