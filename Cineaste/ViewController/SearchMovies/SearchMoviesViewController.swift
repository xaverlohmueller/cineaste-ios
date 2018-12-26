//
//  SearchMoviesViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 spacepandas.de. All rights reserved.
//

import UIKit

class SearchMoviesViewController: UIViewController {
    @IBOutlet weak var loadingIndicatorView: UIView!

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.prefetchDataSource = self
            tableView.delegate = self

            tableView.estimatedRowHeight = 100
            tableView.rowHeight = UITableView.automaticDimension

            tableView.backgroundColor = UIColor.clear
            tableView.tableFooterView = loadingIndicatorView
        }
    }

    var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()

                if self.movies.isEmpty {
                    self.tableView.tableFooterView = UIView()
                }
            }
        }
    }

    let movieSearchController = MovieSearchController()

    var selectedMovie: Movie?
    var storageManager: MovieStorage?

    var isLoadingNextPage = false

    var searchDelayTimer: Timer?

    lazy var resultSearchController: SearchController = {
        let resultSearchController = SearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.delegate = self
        return resultSearchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = String.addMovieTitle

        view.backgroundColor = UIColor.basicBackground

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        movieSearchController.searchMovies { [weak self] movies in
            self?.movies = movies.value ?? []
        }

        configureSearchController()
        registerForPreviewing(with: self, sourceView: tableView)
    }

    func configure(with storageManager: MovieStorage) {
        self.storageManager = storageManager
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if #available(iOS 11.0, *) {
            return
        } else {
            resultSearchController.searchBar.sizeToFit()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showMovieDetail?:
            guard let selectedMovie = selectedMovie,
                let storageManager = storageManager
                else { return }

            let vc = segue.destination as? MovieDetailViewController
            vc?.configure(with: .network(selectedMovie),
                          type: .search,
                          storageManager: storageManager)
        default:
            return
        }
    }

    // MARK: - Actions

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    // MARK: - Configuration

    func configureSearchController() {
        if #available(iOS 11.0, *) {
            navigationItem.searchController = resultSearchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = resultSearchController.searchBar
        }

        definesPresentationContext = true
    }

    // MARK: - Custom functions

    func scrollToTopCell(withAnimation: Bool) {
        guard !movies.isEmpty else { return }

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath,
                                       at: .top,
                                       animated: withAnimation)
        }
    }
}

extension SearchMoviesViewController: SearchMoviesCellDelegate {
    func searchMoviesCell(didTriggerActionButtonFor movie: Movie, watched: Bool) {

        Webservice.loadDetails(movie.id) { result in
            guard let detailedMovie = result.value else {
                self.showAlert(withMessage: Alert.loadingDataError)
                return
            }

            detailedMovie.poster = movie.poster

            do {
                try Current.persistence.insert(movie: detailedMovie)
                self.dismiss(animated: true, completion: nil)
            } catch {
                self.showAlert(withMessage: Alert.insertMovieError)
            }
            self.resultSearchController.isActive = false
        }
    }
}

extension SearchMoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .search }
    static var storyboardID: String? { return "SearchMoviesViewController" }
}
