//
//  PopupDialog.swift
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

/// Creates a Popup dialog similar to UIAlertController
@objc open class PopupDialog: UIViewController {

    // MARK: Private / Internal

    /// First init flag
    private var initialized = false

    /// The completion handler
    private var completion: (() -> Void)? = nil

    /// The custom transition presentation manager
    private var presentationManager: PresentationManager!

    /// Interactor class for pan gesture dismissal
    private lazy var interactor: InteractiveTransition = {
       return InteractiveTransition()
    }()

    /// Returns the controllers view
    internal var popupContainerView: PopupDialogContainerView {
        return view as! PopupDialogContainerView
    }

    /// The set of buttons
    private var buttons = [PopupDialogButton]()

    /// Whether keyboard has shifted view
    internal var keyboardShown = false

    /// Keyboard height
    internal var keyboardHeight: CGFloat? = nil

    // MARK: Public

    /// The content view of the popup dialog
    @objc public var viewController: UIViewController

    /// Whether or not to shift view for keyboard display
    @objc public var keyboardShiftsView = true

    // MARK: - Initializers

    /*!
     Creates a standard popup dialog with title, message and image field

     - parameter title:            The dialog title
     - parameter message:          The dialog message
     - parameter image:            The dialog image
     - parameter buttonAlignment:  The dialog button alignment
     - parameter transitionStyle:  The dialog transition style
     - parameter gestureDismissal: Indicates if dialog can be dismissed via pan gesture
     - parameter completion:       Completion block invoked when dialog was dismissed

     - returns: Popup dialog default style
     */
    @objc public convenience init(
                title: String?,
                message: String?,
                image: UIImage? = nil,
                buttonAlignment: NSLayoutConstraint.Axis = .vertical,
                transitionStyle: PopupDialogTransitionStyle = .BounceUp,
                gestureDismissal: Bool = true,
                completion: (() -> Void)? = nil) {

        // Create and configure the standard popup dialog view
        let viewController = PopupDialogDefaultViewController()
        viewController.titleText   = title
        viewController.messageText = message
        viewController.image       = image

        // Call designated initializer
        self.init(viewController: viewController, buttonAlignment: buttonAlignment, transitionStyle: transitionStyle, gestureDismissal: gestureDismissal, completion: completion)
    }

    /*!
     Creates a popup dialog containing a custom view

     - parameter viewController:   A custom view controller to be displayed
     - parameter buttonAlignment:  The dialog button alignment
     - parameter transitionStyle:  The dialog transition style
     - parameter gestureDismissal: Indicates if dialog can be dismissed via pan gesture
     - parameter completion:       Completion block invoked when dialog was dismissed

     - returns: Popup dialog with a custom view controller
     */
    @objc public init(
        viewController: UIViewController,
        buttonAlignment: NSLayoutConstraint.Axis = .vertical,
        transitionStyle: PopupDialogTransitionStyle = .BounceUp,
        gestureDismissal: Bool = true,
        completion: (() -> Void)? = nil) {

        self.viewController = viewController
        self.completion = completion
        super.init(nibName: nil, bundle: nil)

        // Init the presentation manager
        presentationManager = PresentationManager(transitionStyle: transitionStyle, interactor: interactor)

        // Assign the interactor view controller
        interactor.viewController = self

        // Define presentation styles
        transitioningDelegate = presentationManager
        modalPresentationStyle = .custom

        // Add our custom view to the container
        popupContainerView.stackView.insertArrangedSubview(viewController.view, atIndex: 0)

        // Set button alignment
        popupContainerView.buttonStackView.axis = buttonAlignment

        // Allow for dialog dismissal on background tap and dialog pan gesture
        if gestureDismissal {
            let panRecognizer = UIPanGestureRecognizer(target: interactor, action: #selector(InteractiveTransition.handlePan))
            popupContainerView.stackView.addGestureRecognizer(panRecognizer)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            popupContainerView.addGestureRecognizer(tapRecognizer)
        }
    }

    // Init with coder not implemented
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View life cycle

    /// Replaces controller view with popup view
    @objc public override func loadView() {
        view = PopupDialogContainerView(frame: UIScreen.main.bounds)
    }

    @objc public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard !initialized else { return }
        appendButtons()
        addObservers()
        initialized = true
    }

    @objc public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }

    deinit {
        completion?()
        completion = nil
    }

    // MARK - Dismissal related

    @objc private func handleTap(sender: UITapGestureRecognizer) {

        // Make sure it's not a tap on the dialog but the background
        let point = sender.location(in: popupContainerView.stackView)
        guard !popupContainerView.stackView.point(inside: point, with: nil) else { return }
        dismiss()
    }

    /*!
     Dismisses the popup dialog
     */
    @objc public func dismiss(completion: (() -> Void)? = nil) {
        dismiss(animated: true) {
            completion?()
        }
    }

    // MARK: - Button related

    /*!
     Appends the buttons added to the popup dialog
     to the placeholder stack view
     */
    private func appendButtons() {
        // Add action to buttons
        if buttons.isEmpty {
            popupContainerView.stackView.removeArrangedSubview(popupContainerView.buttonStackView)
        }

        for (index, button) in buttons.enumerated() {
            button.needsLeftSeparator = popupContainerView.buttonStackView.axis == .horizontal && index > 0
            popupContainerView.buttonStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }

    /*!
     Adds a single PopupDialogButton to the Popup dialog
     - parameter button: A PopupDialogButton instance
     */
    @objc public func addButton(button: PopupDialogButton) {
        buttons.append(button)
    }

    /*!
     Adds an array of PopupDialogButtons to the Popup dialog
     - parameter buttons: A list of PopupDialogButton instances
     */
    @objc public func addButtons(buttons: [PopupDialogButton]) {
        self.buttons += buttons
    }

    /// Calls the action closure of the button instance tapped
    @objc private func buttonTapped(button: PopupDialogButton) {
        if button.dismissOnTap {
            dismiss() { button.buttonAction?() }
        } else {
            button.buttonAction?()
        }
    }

    /*!
     Simulates a button tap for the given index
     Makes testing a breeze
     - parameter index: The index of the button to tap
     */
    @objc public func tapButtonWithIndex(index: Int) {
        let button = buttons[index]
        button.buttonAction?()
    }
}

// MARK: - View proxy values

extension PopupDialog {

    /// The button alignment of the alert dialog
    @objc public var buttonAlignment: NSLayoutConstraint.Axis {
        get { return popupContainerView.buttonStackView.axis }
        set {
            popupContainerView.buttonStackView.axis = newValue
            popupContainerView.pv_layoutIfNeededAnimated()
        }
    }

    /// The transition style
    @objc public var transitionStyle: PopupDialogTransitionStyle {
        get { return presentationManager.transitionStyle }
        set { presentationManager.transitionStyle = newValue }
    }
}
