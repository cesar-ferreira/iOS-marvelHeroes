//
//  CharacterTableViewCell.swift
//  Marvel Heroes
//
//  Created by Altran3496 on 24/04/21.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

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
        self.isRemote ? favoriteButton.setImage(UIImage(systemName: "star"), for: .normal) : favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
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
        isFavorite = false
    }

    private func addFavorite() {
        print("TAPPED FAVORITE")
        print(isRemote)
        self.isRemote ? self.saveObject() : self.removeObject()

    }

    private func removeObject() {
        do {
            context.delete(characterLocal!)
            try context.save()
        } catch {
            print("remove")
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
        } catch {
            print("ERro ao add remote")
        }
    }

//    private func saveFromLocalObject() {
//        do {
//            let thumbnail = ThumbnailLocal(context: context)
//            thumbnail.path = self.character?.thumbnail?.path
//            thumbnail.extensionThumbnail = self.character?.thumbnail?.extensionThumbnail
//
//            let favorite = CharacterLocal(context: context)
//            favorite.id = Int64((self.character?.id)!)
//            favorite.name = self.character?.name
//            favorite.descriptionCharacter = self.character?.description
//            favorite.thumbnail = thumbnail
//
//            try context.save()
//        } catch {
//            print("ERro ao add remote")
//        }
//    }
}

