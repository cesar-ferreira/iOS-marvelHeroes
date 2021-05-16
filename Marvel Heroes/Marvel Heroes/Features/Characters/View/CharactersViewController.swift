//
//  CharactersViewController.swift
//  Marvel Heroes
//
//  Created by César Ferreira on 24/04/21.
//

import UIKit
import CoreData

class CharactersViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var charactersTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    private let searchController = UISearchController()
    private let refreshControl = UIRefreshControl()

    private let viewModel = CharactersViewModel()
    private var charactersRemote: [Character] = []
    private var charactersLocal: [CharacterLocal] = []

    var isRemote: Bool = true
    private var fetchedResultsController: NSFetchedResultsController<CharacterLocal>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isRemote ? self.getRemoteCharacters(nameStartsWith: nil) : self.getLocalCharacters(nameStartsWith: nil)
    }
}

extension CharactersViewController {

    private func setup() {
        self.setupTableView()
        self.setupSearchBar()
        self.setupFetchedResultsController()
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
            self.isRemote ? self.getRemoteCharacters(nameStartsWith: text) : self.getLocalCharacters(nameStartsWith: text)
        } else {
            self.isRemote ? self.getRemoteCharacters(nameStartsWith: nil) : self.getLocalCharacters(nameStartsWith: nil)
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
        viewController.isFavorite = self.isRemote ? viewModel.checkFavorite(id: self.charactersRemote[indexPath.row].id ?? 0) : true
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
        cell.delegate = self

        if self.isRemote {
            let character = self.charactersRemote[indexPath.row]
            cell.character = character
            cell.nameLabel.text = character.name
            cell.isRemote = self.isRemote

            if let path = character.thumbnail?.path {
                if let extensionThumbnail = character.thumbnail?.extensionThumbnail {
                    let url = "\(path).\(extensionThumbnail)"
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

extension CharactersViewController : CharacterTableViewCellProtocol {
    func didError(message: String) {
        self.alertError(message: message)
    }
}

extension CharactersViewController: NSFetchedResultsControllerDelegate {

    private func getLocalCharacters(nameStartsWith: String?) {
        self.loading(isLoading: true)
        if let text = nameStartsWith {
            let predicate = NSPredicate(format: "name CONTAINS[c] %@", text)
            fetchedResultsController.fetchRequest.predicate = predicate
            if let myCharacterLocal = fetchedResultsController.fetchedObjects {
                self.charactersLocal = myCharacterLocal
                self.charactersTableView.reloadData()
                self.setupEmpytView()
                self.loading(isLoading: false)
            }
        } else {
            if let myCharacterLocal = fetchedResultsController.fetchedObjects {
                self.charactersLocal = myCharacterLocal
                self.charactersTableView.reloadData()
                self.setupEmpytView()
                self.loading(isLoading: false)
            }
        }
    }

    private func setupFetchedResultsController() {
        self.loading(isLoading: true)
        let fetchRequest:NSFetchRequest<CharacterLocal> = CharacterLocal.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.viewModel.context, sectionNameKeyPath: nil, cacheName: "characterLocal")

        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            self.loading(isLoading: false)
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let myCharacterLocal = anObject as? CharacterLocal else {
            return
        }
        switch type {
        case .insert:
            self.isRemote ? nil : self.charactersLocal.append(myCharacterLocal)
            self.charactersTableView.reloadData()
            self.setupEmpytView()
            break
        case .delete:
            self.isRemote ? nil : self.charactersLocal.remove(at: indexPath!.row)
            self.charactersTableView.reloadData()
            self.setupEmpytView()
        default: break
        }
    }
}
