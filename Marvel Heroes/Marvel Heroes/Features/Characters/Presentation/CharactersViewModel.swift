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

    func checkFavorite(id: Int) -> Bool {
        var isFavorite = false

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterLocal")
            fetchRequest.predicate = NSPredicate(format: "id == \(Int64(id ))")
            let fetchedResults = try context.fetch(fetchRequest)
            if fetchedResults.first != nil {
                isFavorite = true
            }
        } catch  {
            print("error when trying to retrieve objects from the database")
        }

        return isFavorite
    }
}
