//
//  CharacterResponse.swift
//  Marvel Heroes
//
//  Created by César Ferreira on 24/04/21.
//

import Foundation

struct Response<T: Decodable>: Decodable {

    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [T]?
}


//struct DataClass<T: Decodable>: Decodable {
//    let items: [T]
//
//    enum CodingKeys: String, CodingKey {
//        case items = "results"
//    }
//}
