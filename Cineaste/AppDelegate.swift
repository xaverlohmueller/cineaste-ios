//
//  AppDelegate.swift
//  Cineaste
//
//  Created by Christian Braun on 16.10.17.
//  Copyright spacepandas.de. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // swiftlint:disable:next discouraged_optional_collection
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(contextDidSave(notification:)),
                         name: NSNotification.Name.NSManagedObjectContextDidSave,
                         object: nil)

        Appearance.setup()

        // check if system launched the app with a quick action
        // return false so performActionForShortcutItem: is not called twice
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem]
            as? UIApplicationShortcutItem {
            _ = handle(shortCut: shortcutItem)
            return false
        }

        return true
    }

    // MARK: - Home Quick Actions

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handle(shortCut: shortcutItem))
    }

    private func handle(shortCut shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = ShortcutIdentifier(rawValue: shortcutType),
            let tabBarVC = window?.rootViewController as? MoviesTabBarController
            else { return false }

        switch shortcutIdentifier {
        case .watchlist:
            tabBarVC.selectedIndex = 0
            return true
        case .seen:
            tabBarVC.selectedIndex = 1
            return true
        case .startMovieNight:
            guard
                let moviesVC = tabBarVC.selectedViewController?
                    .children.first as? MoviesViewController
                else { return false }

            moviesVC.movieNightButtonTouched(UIBarButtonItem())
            return true
        }

    }

    // MARK: - Core Data

    @objc
    func contextDidSave(notification: Notification) {
        AppDelegate.viewContext.perform {
            AppDelegate.viewContext.mergeChanges(fromContextDidSave: notification)
        }
    }

    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    static var viewContext: NSManagedObjectContext {
        return AppDelegate.persistentContainer.viewContext
    }
}
