//
//  CharacterDetailsViewModel.swift
//  Marvel Heroes
//
//  Created by César Ferreira on 29/04/21.
//

import Foundation
import UIKit
import CoreData

protocol CharacterDetailsViewModelProtocol {
    func didError(message: String)
}

class CharacterDetailsViewModel {

    var delegate: CharacterDetailsViewModelProtocol?

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func addFavorite(isRemote: Bool, isFavorite: Bool, characterRemote: Character?, characterLocal: CharacterLocal?) -> Bool {

        if isRemote && !isFavorite {
            self.saveObject(characterRemote: characterRemote!)
        } else {
            isRemote ? self.removeObject(characterLocal: self.getCharacterLocalById(id: characterRemote?.id ?? 0)!) : self.removeObject(characterLocal: characterLocal!)
        }
        return (isRemote && !isFavorite)
    }

    private func removeObject(characterLocal: CharacterLocal) {
        do {
            context.delete(characterLocal)
            try context.save()
        } catch {
            delegate?.didError(message: "error when trying to remove objects from the database")
        }
    }

    private func saveObject(characterRemote: Character) {
        do {
            let thumbnail = ThumbnailLocal(context: context)
            thumbnail.path = characterRemote.thumbnail?.path
            thumbnail.extensionThumbnail = characterRemote.thumbnail?.extensionThumbnail

            let favorite = CharacterLocal(context: context)
            favorite.id = Int64((characterRemote.id)!)
            favorite.name = characterRemote.name
            favorite.descriptionCharacter = characterRemote.description
            favorite.thumbnail = thumbnail

            try context.save()
        } catch {
            delegate?.didError(message: "error when trying to add objects from the database")
        }
    }

    private func getCharacterLocalById(id: Int) -> CharacterLocal? {
        var characterLocal: CharacterLocal?
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterLocal")
            fetchRequest.predicate = NSPredicate(format: "id == \(Int64(id))")
            let fetchedResults = try context.fetch(fetchRequest)
            if let exists = fetchedResults.first {
                characterLocal = exists as? CharacterLocal
            }
        } catch  {
            delegate?.didError(message: "error when trying to retrieve objects from the database")
        }
        return characterLocal
    }
}
