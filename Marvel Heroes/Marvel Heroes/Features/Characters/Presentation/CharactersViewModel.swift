//
//  CharactersViewModel.swift
//  Marvel Heroes
//
//  Created by César Ferreira on 24/04/21.
//

import Foundation
import UIKit
import CoreData

class CharactersViewModel {

    private let networkManager: NetworkManager
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getRemoteCharacters(nameStartsWith: String?, completion: @escaping (Result<ResponseData<Character>, Error>) -> ()) {
        networkManager.characters(nameStartsWith: nameStartsWith, completion: { result in
            completion(result)
        })
    }

//    func getLocalCharacters(nameStartsWith: String?, completion: @escaping (Hero) -> ()) {
//
////        do {
////            let characters = try context.fetch(Hero.fetchRequest())
////        } catch {
////
////        }
//        completion(try context.fetch(Hero.fetchRequest()) as! Hero)
//
//
////        networkManager.characters(nameStartsWith: nameStartsWith, completion: { result in
////            completion(result)
////        })
//    }
}
