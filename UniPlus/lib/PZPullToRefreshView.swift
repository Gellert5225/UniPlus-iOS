//
//  PZPullRefreshView.swift
//  PZPullToRefresh
//
//  Created by pixyzehn on 3/19/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

/**
 Used to update the UI of the NewstQueryTableViewController.
 */
@objc public protocol PZPullToRefreshDelegate: class {
    /**
     If the refresh view is triggered, then start reloading the table.
     
     - parameter view: The refresh view
     */
    func pullToRefreshDidTrigger(_ view: PZPullToRefreshView) -> ()
    /**
     Return the current date after the refresh view finishes loading.
     
     - parameter view: The refresh view
     */
    @objc optional func pullToRefreshLastUpdated(_ view: PZPullToRefreshView) -> Date
}

/**
 The 3 phases of the refresh view
 */
public enum RefreshState {
    ///The refresh view is not loading
    case normal
    ///The refresh view is being pulled down
    case pulling
    ///The refresh view is released and starts loading/animating
    case loading
}

/**
 Custom pull to refresh view.
 */
open class PZPullToRefreshView: UIView {
    
    // MARK: UI Configuration
    
    /**
     The color of the status text (Loading/Pull down to refresh/Release to refresh).
     */
    @objc open var statusTextColor: UIColor? {
        didSet {
            activityView?.color = statusTextColor
            statusLabel?.textColor = statusTextColor
        }
    }//UIColor(red: 53/255.0, green:111/255.0, blue:177/255.0, alpha: 1)
    /**
     The color of the time text (Last updated:...).
     */
    open var timeTextColor = UIColor(red: 53/255.0, green:111/255.0, blue:177/255.0, alpha: 1)
    /**
     The background color of the refresh view.
     */
    @objc open var bgColor: UIColor? {
        didSet {
            backgroundColor = bgColor
        }
    }//= UIColor(red:239/255.0, green:239/255.0, blue:244/255.0, alpha: 1)
    /**
     The animation duration for the little arrow.
     */
    open var flipAnimatioDutation: CFTimeInterval = 0.18
    /**
     The threshold for the change of [RefreshState](file:///Users/JiaheLi/Desktop/UniPlus/JazzyDocSwift/Enums/RefreshState.html)
     */
    @objc open var thresholdValue: CGFloat = 40.0
    
    /// :nodoc:
    open var lastUpdatedKey = "RefreshLastUpdated"
    /**
     Whether the refresh view should show the time text or not.
     */
    open var isShowUpdatedTime = true
    
    // MARK: Outlets
    
    /**
     The label that displays the last updated time
     */
    open var lastUpdatedLabel: UILabel?
    /**
     The label that displays the refresh view status
     */
    open var statusLabel: UILabel?
    /**
     The image layer that diplays the little arrow
     */
    open var arrowImage: CALayer?
    /**
     An animating activity indicator if the current state is `.loading`
     */
    open var activityView: UIActivityIndicatorView?
    
    @objc open var arrow: UIImage? {
        didSet {
            arrowImage?.contents = arrow?.cgImage
        }
    }
    
    // MARK: Logics
    
    fileprivate var _isLoading = false
    /**
     Whether the refresh view is loading or not.
     */
    @objc open var isLoading: Bool {
        get {
            return _isLoading
        }
        set {
            _isLoading = state == .loading
        }
    }
    /**
     The current state of the refresh view: `.normal`
     */
    open var _state: RefreshState = .normal
    /// :nodoc:
    open var state: RefreshState {
        get {
           return _state
        }
        set {
            switch newValue {
            case .normal:
                statusLabel?.text = "Pull down to refresh"
                activityView?.stopAnimating()
                refreshLastUpdatedDate()
                rotateArrowImage(0)
            case .pulling:
                statusLabel?.text = "Release to refresh"
                rotateArrowImage(CGFloat(Double.pi))
            case .loading:
                statusLabel?.text = "Loading..."
                activityView?.startAnimating()
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                arrowImage?.isHidden = true
                CATransaction.commit()
            }
            _state = newValue
        }
    }
    
    /**
     The PZPullToRefreshDelegate
     */
    @objc open weak var delegate: PZPullToRefreshDelegate?
    /// :nodoc:
    open var lastUpdatedLabelCustomFormatter: ( (_ date:Date)->String )?
    
    fileprivate func rotateArrowImage(_ angle: CGFloat) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(flipAnimatioDutation)
        arrowImage?.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        CATransaction.commit()
    }
    
    /// :nodoc:
    override public init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleWidth
        backgroundColor = bgColor

        let label = UILabel(frame: CGRect(x: 0, y: frame.size.height - 22.0, width: frame.size.width, height: 20.0))
        label.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        label.font = UIFont(name: "SFUIText-Light", size: 12)
        label.textColor = timeTextColor
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        lastUpdatedLabel = label
        if let time = UserDefaults.standard.object(forKey: lastUpdatedKey) as? String {
            lastUpdatedLabel?.text = time

        } else {
            lastUpdatedLabel?.text = nil
        }
        //addSubview(label)
        
        statusLabel = UILabel(frame: CGRect(x: 50, y: frame.size.height - 30.0, width: frame.size.width - 50, height: 20.0))
        statusLabel?.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        statusLabel?.font             = UIFont(name: "SFUIText-Regular", size: 12)
        statusLabel?.textColor        = statusTextColor
        statusLabel?.backgroundColor  = UIColor.clear
        statusLabel?.textAlignment    = .left
        addSubview(statusLabel!)
        
        arrowImage = CALayer()
        arrowImage?.frame           = CGRect(x: 15, y: frame.size.height - 40.0, width: 25.0, height: 40.0)
        arrowImage?.contentsGravity = CALayerContentsGravity.resizeAspect
        arrowImage?.contents        = (arrow ?? UIImage(named:"whiteArrow")!).cgImage
        layer.addSublayer(arrowImage!)
        
        activityView     = UIActivityIndicatorView(style: .white)
        activityView?.color   = statusTextColor
        activityView?.frame   = CGRect(x: 20, y: frame.size.height - 26.0, width: 15.0, height: 15.0)
        addSubview(activityView!)
        
        state = .normal
    }

    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Instance Methods
    
    /**
     Set the latest updated date.
     */
    @objc open func refreshLastUpdatedDate() {
        if isShowUpdatedTime {
            if let date = delegate?.pullToRefreshLastUpdated?(self) {
                var lastUpdateText:String
                if let customFormatter = self.lastUpdatedLabelCustomFormatter {
                    lastUpdateText = customFormatter(date)
                }else{
                    let formatter = DateFormatter()
                    formatter.amSymbol = "AM"
                    formatter.pmSymbol = "PM"
                    formatter.dateFormat = "MMM dd - HH:mm"
                    lastUpdateText = "Last Updated: \(formatter.string(from: date))"
                }
                lastUpdatedLabel?.text = lastUpdateText
                let userDefaults = UserDefaults.standard
                userDefaults.set(lastUpdatedLabel?.text, forKey: lastUpdatedKey)
                userDefaults.synchronize()
            }
        }
    }

    // MARK: ScrollView Methods
    
    /**
     Change the state of the refresh view by comparing the scroll view offset with the threshold value
     
     - parameter scrollView: The scroll view in which the refresh view is contained.
     */
    @objc open func refreshScrollViewDidScroll(_ scrollView: UIScrollView) {
        if state == .loading {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.2)
            var offset = max(scrollView.contentOffset.y * -1, 0)
            offset = min(offset, thresholdValue)
            //scrollView.setContentOffset(CGPoint(x:0.0, y:-offset), animated: true)
            scrollView.contentInset = UIEdgeInsets(top: offset, left: 0.0, bottom: 0.0, right: 0.0)
            UIView.commitAnimations()

        } else if scrollView.isDragging {
            let loading = false
            if state == .pulling && scrollView.contentOffset.y > -thresholdValue && scrollView.contentOffset.y <= 0.0 && !loading {
                state = .normal

            } else if state == .normal && scrollView.contentOffset.y < -thresholdValue && !loading {
                state = .pulling
            }
        }
    }
    
    /**
     Determines whether the refresh view should start animating or go back to `.normal` state.
     
     ```
     if scrollView.contentOffset.y <= -thresholdValue && !loading {
        state = .loading
        delegate?.pullToRefreshDidTrigger(self)
     }
     ```
     
     - parameter scrollView: The scroll view in which the refresh view is contained.
     */
    @objc open func refreshScrollViewDidEndDragging(_ scrollView: UIScrollView) {
        let loading = false
        if scrollView.contentOffset.y <= -thresholdValue && !loading {
            state = .loading
            delegate?.pullToRefreshDidTrigger(self)
        }
    }
    
    /**
     Animate the refresh view back to `.normal` if the table view finishes loading.
     
     - parameter scrollView: The scroll view in which the refresh view is contained.
     */
    @objc open func refreshScrollViewDataSourceDidFinishedLoading(_ scrollView: UIScrollView, _ inset: UIEdgeInsets) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        scrollView.contentInset = inset
        UIView.commitAnimations()
        arrowImage?.isHidden = false
        state = .normal
    }
    
    @objc open func refreshScrollViewDataSourceDidFinishedLoading(_ scrollView: UIScrollView) {
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(0.3)
//        UIView.commitAnimations()
        arrowImage?.isHidden = false
        state = .normal
    }
    
    /**
     Let the refresh view begin refreshing.
     
     - parameter scrollView: The scroll view in which the refresh view is contained.
     */
    func beginRefresh (_ scrollView: UIScrollView){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        var offset = max(scrollView.contentOffset.y * -1, 0)
        offset = min(offset, thresholdValue)
        scrollView.contentInset = UIEdgeInsets(top: thresholdValue, left: 0.0, bottom: 0.0, right: 0.0)
        UIView.commitAnimations()
    }
    
}
