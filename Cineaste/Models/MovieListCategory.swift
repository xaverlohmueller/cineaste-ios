//
//  MyMoviesCategory.swift
//  Cineaste
//
//  Created by Christian Braun on 28.01.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit
import CoreData

enum MovieListCategory: String {
    case watchlist
    case seen

    var title: String {
        switch self {
        case .watchlist:
            return String.watchlist
        case .seen:
            return String.seen
        }
    }

    var image: UIImage {
        switch self {
        case .watchlist:
            return UIImage.watchlistIcon
        case .seen:
            return UIImage.seenIcon
        }
    }

    var action: String {
        switch self {
        case .watchlist:
            return String.watchlistAction
        case .seen:
            return String.seenAction
        }
    }

    var predicate: NSPredicate {
        switch self {
        case .watchlist:
            return NSPredicate(format: "watched == %@", NSNumber(value: false))
        case .seen:
            return NSPredicate(format: "watched == %@", NSNumber(value: true))
        }
    }

    var sortDescriptors: [NSSortDescriptor] {
        switch self {
        case .watchlist:
            return StoredMovie.defaultSortDescriptors
        case .seen:
            return StoredMovie.seenMoviesSortDescriptors
        }
    }

    var detailType: MovieDetailType {
        switch self {
        case .watchlist:
            return MovieDetailType.watchlist
        case .seen:
            return MovieDetailType.seen
        }
    }

    func datasource(for tableView: UITableView) -> UITableViewDataSource {
        let request: NSFetchRequest<StoredMovie> = StoredMovie.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: AppDelegate.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        switch self {
        case .watchlist:
            return TableViewDataSource<WantToSeeMovieCell>(
                tableView: tableView,
                fetchedResultsController: frc
            )
        case .seen:
            return TableViewDataSource<SeenMovieCell>(
                tableView: tableView,
                fetchedResultsController: frc
            )
        }
    }
}
