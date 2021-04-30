//
//  ApiClient.swift
//  Marvel Heroes
//
//  Created by César Ferreira on 24/04/21.
//

import Moya

enum ApiClient {
    case characters(nameStartsWith: String?)
}

extension ApiClient: TargetType {

    var baseURL: URL {
        guard let url = URL(string: "https://gateway.marvel.com:443/v1/public") else { fatalError() }
        return url
    }

    var apiKey: String {
        return "4becc2a3a00dc873bff3def094c82ce4"
    }

    var ts: String {
        return "noname"
    }

    var hash: String {
        return "a3578226243404d4d39d0541b1934202"
    }

    var limit: String {
        return "100"
    }

    var path: String {
        switch self {
        case .characters:
            return "/characters"
        }
    }

    var method: Method {
        switch self {
        case .characters:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .characters(let nameStartsWith):
            var parameters: [String: Any] = ["limit": limit, "apikey": apiKey, "ts": ts, "hash": hash]

            if let nameStartsWith = nameStartsWith {
                parameters["nameStartsWith"] = nameStartsWith
            }

            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
}

