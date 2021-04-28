//
//  CharactersViewController.swift
//  Marvel Heroes
//
//  Created by César Ferreira on 24/04/21.
//

import UIKit
import CoreData

class CharactersViewController: UIViewController, StoryboardInstantiable {

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    @IBOutlet weak var charactersTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    private let searchController = UISearchController()
    
    private let viewModel = CharactersViewModel()
    private var charactersRemote: [Character] = []
    private var charactersLocal: [CharacterLocal] = []

    var isRemote: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()



//        isRemote ? self.getRemoteCharacters(nameStartsWith: nil) : getLocalCharacters(nameStartsWith: nil)
        self.setup()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isRemote ? self.getRemoteCharacters(nameStartsWith: nil) : getLocalCharacters(nameStartsWith: nil)
    }
}

extension CharactersViewController {

    private func setup() {
        self.setupTableView()
        self.setupSearchBar()
    }

    private func setupSearchBar() {
        title = "Lista"

        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    private func setupTableView() {
        self.charactersTableView.register(CharacterTableViewCell.nib(), forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)

        self.charactersTableView.delegate = self
        self.charactersTableView.dataSource = self
    }

    private func setupEmpytView() {
        let isEmpyt: Bool = self.isRemote ? self.charactersRemote.count == 0 : self.charactersLocal.count == 0
        self.emptyView.isHidden = !isEmpyt
    }

    private func getRemoteCharacters(nameStartsWith: String?) {
        self.loading(isLoading: true)
        self.viewModel.getRemoteCharacters(nameStartsWith: nameStartsWith, completion: { result in
            self.loading(isLoading: false)
            switch result {
            case .success(let response):
                self.charactersRemote = response.data.results ?? []
                self.charactersTableView.reloadData()
                self.setupEmpytView()
            case .failure(let error):
                self.alertError(message: error.localizedDescription)

            }
        })
    }

    private func getLocalCharacters(nameStartsWith: String?) {
        self.loading(isLoading: true)

        do {
            self.charactersLocal = try context.fetch(CharacterLocal.fetchRequest())
            self.loading(isLoading: false)

            self.charactersTableView.reloadData()
            self.setupEmpytView()
        } catch  {
            print("!ERROOOOOROROROROR")
        }
    }

    private func loading(isLoading: Bool) {
        self.loadingView.isHidden = !isLoading
        self.loadingIndicator.isHidden = !isLoading
        isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
    }

    private func alertError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CharactersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 1 {
            self.getRemoteCharacters(nameStartsWith: text)
        }
    }
}

extension CharactersViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension CharactersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isRemote ? self.charactersRemote.count : self.charactersLocal.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = CharacterDetailsViewController.instantiateViewController()
        viewController.isRemote = self.isRemote
        if self.isRemote {
            let character = self.charactersRemote[indexPath.row]
            viewController.character = character
        } else {
            let characterLocal = self.charactersLocal[indexPath.row]
            viewController.characterLocal = characterLocal
        }

        viewController.modalPresentationStyle = .fullScreen
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as! CharacterTableViewCell

        if self.isRemote {
            let character = self.charactersRemote[indexPath.row]
            cell.character = character
            cell.nameLabel.text = character.name
            cell.isRemote = self.isRemote

            if let path = character.thumbnail?.path {
                if let extensionThumbnail = character.thumbnail?.extensionThumbnail {
                    let url = "\(path).\(extensionThumbnail)"
                    print(url)
                    cell.imageHero.downloaded(from: url)
                }
            }
        } else {
            let characterLocal = self.charactersLocal[indexPath.row]
            cell.characterLocal = characterLocal
            cell.nameLabel.text = characterLocal.name
            cell.isRemote = self.isRemote

            if let path = characterLocal.thumbnail?.path {
                if let extensionThumbnail = characterLocal.thumbnail?.extensionThumbnail {
                    let url = "\(path).\(extensionThumbnail)"
                    print(url)
                    cell.imageHero.downloaded(from: url)
                }
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
