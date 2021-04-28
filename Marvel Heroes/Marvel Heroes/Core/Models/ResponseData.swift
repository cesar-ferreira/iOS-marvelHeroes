//
//  DataResponse.swift
//  Marvel Heroes
//
//  Created by César Ferreira on 24/04/21.
//

import Foundation

struct ResponseData<T: Decodable>: Decodable {

    let code: Int?
    let status: String?
    let data: Response<T>
}

