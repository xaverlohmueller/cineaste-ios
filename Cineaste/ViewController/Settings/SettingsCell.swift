//
//  SettingsCell.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    static let identifier = "SettingsCell"

    @IBOutlet weak var title: TitleLabel!
    @IBOutlet weak var descriptionLabel: DescriptionLabel!

    func configure(with settingsItem: SettingItem) {
        title.text = settingsItem.title

        if let description = settingsItem.description {
            descriptionLabel.isHidden = false
            descriptionLabel.text = description
        } else {
            descriptionLabel.isHidden = true
        }
    }

}
