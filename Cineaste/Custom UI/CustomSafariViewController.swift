//
//  CustomSafariViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 12.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit
import SafariServices

class CustomSafariViewController: SFSafariViewController {
    @available(iOS 11.0, *)
    override init(url URL: URL, configuration: SFSafariViewController.Configuration) {
        super.init(url: URL, configuration: configuration)

        setup()
    }

    override init(url URL: URL, entersReaderIfAvailable: Bool) {
        super.init(url: URL, entersReaderIfAvailable: entersReaderIfAvailable)

        setup()
    }

    private func setup() {
        preferredBarTintColor = .safariBarTint
        preferredControlTintColor = .basicWhite
    }
}
