//
//  CharacterTableViewCell.swift
//  Marvel Heroes
//
//  Created by César Ferreira on 24/04/21.
//

import UIKit
import CoreData

protocol CharacterTableViewCellProtocol {
    func didError(message: String)
}

class CharacterTableViewCell: UITableViewCell {

    var delegate: CharacterTableViewCellProtocol?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    static let reuseIdentifier = "CharacterTableViewCell"

    @IBOutlet weak var imageHero: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    var character: Character? = nil
    var characterLocal: CharacterLocal? = nil

    var isRemote: Bool = true
    var isFavorite: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.isRemote ? self.checkFavorite() : favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }

    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        self.addFavorite()
    }
}

extension CharacterTableViewCell {

    private func checkFavorite() {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterLocal")
            fetchRequest.predicate = NSPredicate(format: "id == \(Int64(character?.id ?? 0))")
            let fetchedResults = try context.fetch(fetchRequest)
            if let exists = fetchedResults.first {
                characterLocal = exists as? CharacterLocal
                favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                self.isFavorite = true
            } else {
                favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                self.isFavorite = false
            }
        } catch  {
            delegate?.didError(message: "error when trying to retrieve objects from the database")
        }
    }

    private func addFavorite() {
        (self.isRemote && !self.isFavorite) ? self.saveObject() : self.removeObject()
    }

    private func removeObject() {
        do {
            context.delete(characterLocal!)
            try context.save()
            checkFavorite()
        } catch {
            delegate?.didError(message: "error when trying to remove objects from the database")
        }
    }

    private func saveObject() {
        do {
            let thumbnail = ThumbnailLocal(context: context)
            thumbnail.path = self.character?.thumbnail?.path
            thumbnail.extensionThumbnail = self.character?.thumbnail?.extensionThumbnail

            let favorite = CharacterLocal(context: context)
            favorite.id = Int64((self.character?.id)!)
            favorite.name = self.character?.name
            favorite.descriptionCharacter = self.character?.description
            favorite.thumbnail = thumbnail

            try context.save()
            checkFavorite()
        } catch {
            delegate?.didError(message: "error when trying to add objects from the database")
        }
    }
}

