//
//  MoviesViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

class MoviesViewController: UITableViewController {
    @IBOutlet private weak var emptyView: UIView!
    @IBOutlet private weak var emptyListTitle: UILabel! {
        didSet {
            emptyListTitle.textColor = .accentTextOnBlack
            emptyListTitle.text = .noContentTitle
        }
    }
    @IBOutlet private weak var emptyListLabel: UILabel! {
        didSet {
            emptyListLabel.textColor = .accentTextOnBlack
        }
    }

    lazy var datasource = TableViewDataSource(
        tableView: tableView,
        cellIdentifier: MovieListCell.identifier,
        fetchedResultsController: self.fetchedResultsManager.controller,
        delegate: self
    )

    var category: MovieListCategory = .watchlist {
        didSet {
            title = category.title
            emptyListLabel.text = String.title(for: category)
            fetchedResultsManager.refetch(for: category.predicate)
        }
    }

    private lazy var resultSearchController: SearchController = {
        let resultSearchController = SearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        return resultSearchController
    }()

    let fetchedResultsManager = FetchedResultsManager()

    var storageManager: MovieStorage?
    var selectedMovie: StoredMovie?
    private var saveAction: UIAlertAction?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.basicBackground

        showEmptyState(fetchedResultsManager.movies.isEmpty)

        registerForPreviewing(with: self, sourceView: tableView)

        configureTableView()
        configureSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showEmptyState(fetchedResultsManager.movies.isEmpty)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        fetchedResultsManager.refetch(for: category.predicate)
        resultSearchController.isActive = false
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if #available(iOS 11.0, *) {
            return
        } else {
            resultSearchController.searchBar.sizeToFit()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let storageManager = storageManager else { return }

        switch Segue(initWith: segue) {
        case .showSearchFromMovieList?:
            let navigationVC = segue.destination as? UINavigationController
            let vc = navigationVC?.viewControllers.first as? SearchMoviesViewController
            vc?.configure(with: storageManager)
        case .showMovieDetail?:
            guard let selectedMovie = selectedMovie else { return }

            let vc = segue.destination as? MovieDetailViewController
            vc?.configure(with: .stored(selectedMovie),
                          type: category.detailType,
                          storageManager: storageManager)
        case .showMovieNight?:
            let navigationVC = segue.destination as? UINavigationController
            let vc = navigationVC?.viewControllers.first as? MovieNightViewController
            vc?.configure(with: storageManager)
        default:
            break
        }
    }

    // MARK: - Action

    @IBAction func movieNightButtonTouched(_ sender: UIBarButtonItem) {
        if UserDefaultsManager.getUsername() == nil {
            askForUsername()
        } else {
            performSegue(withIdentifier: Segue.showMovieNight.rawValue, sender: nil)
        }
    }

    // MARK: - Configuration

    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.basicBackground

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80

        tableView.backgroundView = emptyView
        tableView.dataSource = datasource
    }

    private func configureSearchController() {
        if #available(iOS 11.0, *) {
            navigationItem.searchController = resultSearchController
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            tableView.tableHeaderView = resultSearchController.searchBar
        }

        definesPresentationContext = true
    }

    // MARK: - Custom functions

    func showEmptyState(_ emptyState: Bool, completion: (() -> Void)? = nil) {
        let isEmpty = emptyState

        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.tableView.backgroundView?.alpha = isEmpty ? 1 : 0
            }, completion: { _ in
                self.tableView.backgroundView?.isHidden = !isEmpty
                completion?()
            })
        }
    }

    private func askForUsername() {
        let alert = UIAlertController(title: Alert.insertUsername.title,
                                      message: Alert.insertUsername.message,
                                      preferredStyle: .alert)
        saveAction = UIAlertAction(title: Alert.insertUsername.action, style: .default) { _ in
            guard let textField = alert.textFields?[0], let username = textField.text else {
                return
            }
            UserDefaultsManager.setUsername(username)
            self.performSegue(withIdentifier: Segue.showMovieNight.rawValue, sender: nil)
        }

        if let saveAction = saveAction {
            saveAction.isEnabled = false
            alert.addAction(saveAction)
        }

        if let cancelTitle = Alert.insertUsername.cancel {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
            alert.addAction(cancelAction)
        }

        alert.addTextField { textField in
            textField.placeholder = String.usernamePlaceholder
            textField.delegate = self
        }

        present(alert, animated: true)
    }

    private func updateShortcutItems() {
        var shortcuts = UIApplication.shared.shortcutItems ?? []

        //initially instantiate shortcuts
        if shortcuts.isEmpty {
            let watchlistIcon = UIApplicationShortcutIcon(templateImageName: "add_to_watchlist")
            let watchlistShortcut =
                UIApplicationShortcutItem(type: ShortcutIdentifier.watchlist.rawValue,
                                          localizedTitle: String.watchlist,
                                          localizedSubtitle: nil,
                                          icon: watchlistIcon,
                                          userInfo: nil)

            let seenIcon = UIApplicationShortcutIcon(templateImageName: "add_to_watchedlist")
            let seenShortcut =
                UIApplicationShortcutItem(type: ShortcutIdentifier.seen.rawValue,
                                          localizedTitle: String.seen,
                                          localizedSubtitle: nil,
                                          icon: seenIcon,
                                          userInfo: nil)

            shortcuts = [watchlistShortcut, seenShortcut]
            UIApplication.shared.shortcutItems = shortcuts
        }

        let index = category == .watchlist ? 0 : 1
        let existingItem = shortcuts[index]

        //only update if value changed
        let newShortcutSubtitle =
            fetchedResultsManager.movies.isEmpty
            ? nil
            : String.movies(for: fetchedResultsManager.movies.count)
        if existingItem.localizedSubtitle != newShortcutSubtitle {
            //swiftlint:disable:next force_cast
            let mutableShortcutItem = existingItem.mutableCopy() as! UIMutableApplicationShortcutItem
            mutableShortcutItem.localizedSubtitle = newShortcutSubtitle

            shortcuts[index] = mutableShortcutItem

            UIApplication.shared.shortcutItems = shortcuts
        }
    }
}

// MARK: - UITextFieldDelegate

extension MoviesViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }

        let entryLength = text.count + string.count - range.length
        saveAction?.isEnabled = entryLength > 0 ? true : false

        return true
    }
}

// MARK: - TableViewDataSourceDelegate
extension MoviesViewController: TableViewDataSourceDelegate {
    func configure(_ cell: MovieListCell, for movie: StoredMovie) {
        cell.configure(with: movie)
    }
}

// MARK: - Instantiable

extension MoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .movieList }
    static var storyboardID: String? { return "MoviesViewController" }
}
