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

    var isRemote: Bool = true
    var character: Character?
    var characterLocal: CharacterLocal?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }
}

extension CharacterDetailsViewController {

    private func setup() {
        self.setupLabel()
        self.setupImage()
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

    private func setupImage() {

        if self.isRemote {
            if let path = self.character?.thumbnail?.path {
                if let extensionThumbnail = self.character?.thumbnail?.extensionThumbnail {
                    let url = "\(path).\(extensionThumbnail)"
                    print(url)
                    self.imageCharacter.downloaded(from: url)
                }
            }
        } else {
            if let path = self.characterLocal?.thumbnail?.path {
                if let extensionThumbnail = self.characterLocal?.thumbnail?.extensionThumbnail {
                    let url = "\(path).\(extensionThumbnail)"
                    print(url)
                    self.imageCharacter.downloaded(from: url)
                }
            }
        }


    }
}
