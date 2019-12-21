//
//  PopupDialogButton.swift
//
//  Copyright (c) 2016 Orderella Ltd. (http://orderella.co.uk)
//  Author - Martin Wildfeuer (http://www.mwfire.de)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

/// Represents the default button for the popup dialog
@objc open class PopupDialogButton: UIButton {

    public typealias PopupDialogButtonAction = () -> Void

    // MARK: Public

    /// The font and size of the button title
    @objc public dynamic var titleFont: UIFont? {
        get { return titleLabel?.font }
        set { titleLabel?.font = newValue }
    }

    /// The title color of the button
    @objc public dynamic var titleColor: UIColor? {
        get { return titleColor(for: .normal) }
        set { setTitleColor(newValue, for: .normal) }
    }

    /// The background color of the button
    @objc public dynamic var buttonColor: UIColor? {
        get { return backgroundColor }
        set { backgroundColor = newValue }
    }

    /// The separator color of this button
    @objc public dynamic var separatorColor: UIColor? {
        get { return separator.backgroundColor }
        set {
            separator.backgroundColor = newValue
            leftSeparator.backgroundColor = newValue
        }
    }

    /// Default appearance of the button
    @objc public var defaultTitleFont      = UIFont.systemFont(ofSize: 14)
    @objc public var defaultTitleColor     = UIColor(red: 0.25, green: 0.53, blue: 0.91, alpha: 1)
    @objc public var defaultButtonColor    = UIColor.clear
    @objc public var defaultSeparatorColor = UIColor(white: 0.9, alpha: 1)

    /// Whether button should dismiss popup when tapped
    @objc public var dismissOnTap = true

    /// The action called when the button is tapped
    @objc public private(set) var buttonAction: PopupDialogButtonAction?

    // MARK: Private

    private lazy var separator: UIView = {
        let line = UIView(frame: .zero)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    private lazy var leftSeparator: UIView = {
        let line = UIView(frame: .zero)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.alpha = 0
        return line
    }()

    // MARK: Internal

    internal var needsLeftSeparator: Bool = false {
        didSet {
            leftSeparator.alpha = needsLeftSeparator ? 1.0 : 0.0
        }
    }

    // MARK: Initializers

    /*!
     Creates a button that can be added to the popup dialog

     - parameter title:         The button title
     - parameter dismisssOnTap: Whether a tap automatically dismisses the dialog
     - parameter action:        The action closure

     - returns: PopupDialogButton
     */
    @objc public init(title: String, dismissOnTap: Bool = true, action: PopupDialogButtonAction?) {

        // Assign the button action
        buttonAction = action

        super.init(frame: .zero)

        // Set the button title
        setTitle(title, for: .normal)

        self.dismissOnTap = dismissOnTap

        // Setup the views
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View setup

    @objc public func setupView() {

        // Default appearance
        setTitleColor(defaultTitleColor, for: .normal)
        titleLabel?.font              = defaultTitleFont
        backgroundColor               = defaultButtonColor
        separator.backgroundColor     = defaultSeparatorColor
        leftSeparator.backgroundColor = defaultSeparatorColor

        // Add and layout views
        addSubview(separator)
        addSubview(leftSeparator)

        let views = ["separator": separator, "leftSeparator": leftSeparator, "button": self]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[button(45)]", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[separator(1)]", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[leftSeparator(1)]", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[leftSeparator]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
    }

    @objc public override var isHighlighted: Bool {
        didSet {
            isHighlighted ? pv_fade(direction: .Out, 0.5) : pv_fade(direction: .In, 1.0)
        }
    }
}
