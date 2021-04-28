//
//  NetworkManager.swift
//  Marvel Heroes
//
//  Created by César Ferreira on 24/04/21.
//

import Moya

protocol Networkable {
    var provider: MoyaProvider<ApiClient> { get }

    func characters(nameStartsWith: String?, completion: @escaping (Result<ResponseData<Character>, Error>) -> ())

}

class NetworkManager: Networkable {

    let provider = MoyaProvider<ApiClient>(plugins: [NetworkLoggerPlugin()])

    func characters(nameStartsWith: String?, completion: @escaping (Result<ResponseData<Character>, Error>) -> ()) {
        request(target: .characters(nameStartsWith: nameStartsWith), completion: completion)
    }
}

private extension NetworkManager {

    private func request<T: Decodable>(target: ApiClient, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
//                    print(String(data: response.data, encoding: .utf8)!)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

