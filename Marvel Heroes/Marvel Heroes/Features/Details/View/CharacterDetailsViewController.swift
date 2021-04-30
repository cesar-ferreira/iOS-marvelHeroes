//
//  CharacterDetailsViewController.swift
//  Marvel Heroes
//
//  Created by César Ferreira on 24/04/21.
//

import UIKit

class CharacterDetailsViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var imageCharacter: UIImageView!
    @IBOutlet weak var nameCharacter: UILabel!
    @IBOutlet weak var descriptionCharacter: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    private let viewModel = CharacterDetailsViewModel()

    var isRemote: Bool = true
    var isFavorite: Bool = false
    var character: Character?
    var characterLocal: CharacterLocal?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.viewModel.delegate = self
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        self.isFavorite = self.viewModel.addFavorite(isRemote: self.isRemote, isFavorite: self.isFavorite, characterRemote: self.character, characterLocal: self.characterLocal)
        self.isFavorite ? favoriteButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal, barMetrics: .default) : favoriteButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal, barMetrics: .default)
    }
}

extension CharacterDetailsViewController {

    private func setup() {
        self.setupLabel()
        self.setupImage()
        self.setupNavigationBar()
    }

    private func setupNavigationBar() {
        self.isFavorite ? favoriteButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal, barMetrics: .default) : favoriteButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal, barMetrics: .default)
    }

    private func setupLabel() {
        title = "Details"

        if self.isRemote {
            self.nameCharacter.text = self.character?.name
            self.descriptionCharacter.text = self.character?.description
        } else {
            self.nameCharacter.text = self.characterLocal?.name
            self.descriptionCharacter.text = self.characterLocal?.descriptionCharacter
        }
    }

    private func alertError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func setupImage() {

        if self.isRemote {
            if let path = self.character?.thumbnail?.path {
                if let extensionThumbnail = self.character?.thumbnail?.extensionThumbnail {
                    let url = "\(path).\(extensionThumbnail)"
                    self.imageCharacter.downloaded(from: url)
                }
            }
        } else {
            if let path = self.characterLocal?.thumbnail?.path {
                if let extensionThumbnail = self.characterLocal?.thumbnail?.extensionThumbnail {
                    let url = "\(path).\(extensionThumbnail)"
                    self.imageCharacter.downloaded(from: url)
                }
            }
        }
    }
}

extension CharacterDetailsViewController : CharacterDetailsViewModelProtocol {
    func didError(message: String) {
        self.alertError(message: message)
    }
}
