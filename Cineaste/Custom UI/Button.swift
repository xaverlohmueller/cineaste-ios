//
//  Button.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

class Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        fatalError("Override this method in your subclass")
    }
}

class ActionButton: Button {
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title?.uppercased(), for: state)
    }

    override func setup() {
        setTitleColor(UIColor.primaryDarkOrange, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
}

class BorderedButton: Button {

    override func setup() {
        tintColor = .primaryOrange

        contentEdgeInsets.top = 10
        contentEdgeInsets.bottom = 10
        contentEdgeInsets.left = 20
        contentEdgeInsets.right = 20

        layer.borderColor = UIColor.primaryOrange.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 4

        titleLabel?.adjustsFontSizeToFitWidth = true
    }
}
