//
//  OfflineBannerView.swift
//  LPCOfflineBannerView
//
//  Created by Alaeddine Ouertani on 15/02/2018.
//  Copyright © 2018 Lakooz. All rights reserved.
//

import UIKit

public final class OfflineBannerView: UIView {
    
    // MARK: Outlets
    
    private var ibViewContainer: UIView!
    private var ibMessageLabel: UILabel!
    
    // MARK: Properties
    
    struct Static {
        fileprivate static var instance: OfflineBannerView!
    }
    
    public static var sharedInstance: OfflineBannerView {
        if Static.instance == nil {
            Static.instance = OfflineBannerView()
        }
        
        return Static.instance
    }
    
    private static let defaultColor = "#E12B42"
    private static let defaultAnimationDuration: Double = 0.3
    private static let defaultCornerRadius: CGFloat = 10
    private static let defaultHeight: CGFloat = 27
    private static let defaultFont = UIFont.systemFont(ofSize: 17)
    
    var height: CGFloat = OfflineBannerView.defaultHeight
    
    private let isIPhoneX = DeviceHelper.isIPhoneX
    private var startY: CGFloat = 0 // It changes if iPhone is X
    private var marginLeftRight: CGFloat = 0 // It changes if iPhone is X
    
    public var text: String? {
        didSet {
            if text != self.ibMessageLabel.text {
                self.ibMessageLabel.text = self.text
                self.updateViewHeight()
            }
        }
    }
    
    public var color: UIColor? {
        didSet {
            if self.isIPhoneX {
                backgroundColor = UIColor.clear
            } else {
                backgroundColor = self.color
            }
            self.ibViewContainer.backgroundColor = self.color
        }
    }
    
    public var textColor: UIColor? {
        didSet {
            self.ibMessageLabel.textColor = self.textColor
        }
    }
    
    public var textAlignment: NSTextAlignment = .center {
        didSet {
            self.ibMessageLabel.textAlignment = self.textAlignment
        }
    }
    
    public var font: UIFont = OfflineBannerView.defaultFont {
        didSet {
            self.ibMessageLabel.font = self.font
            self.updateViewHeight()
        }
    }
    
    public var animationDuration: Double = OfflineBannerView.defaultAnimationDuration
    
    // MARK: Overrides
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("This custom view must not be used inside a .xib file")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let rootView = UIApplication.shared.keyWindow {
            if self.isIPhoneX {
                self.marginLeftRight = 10
            }
            let newContainerFrame = CGRect(x: self.marginLeftRight, y: 0, width: rootView.frame.width - (self.marginLeftRight * 2), height: self.height)
            let newLabelFrame = CGRect(x: self.marginLeftRight, y: 0, width: newContainerFrame.width - (self.marginLeftRight * 2), height: self.height)
            
            self.ibViewContainer = UIView(frame: newContainerFrame)
            self.ibMessageLabel = UILabel(frame: newLabelFrame)
            
            self.ibViewContainer.addSubview(ibMessageLabel)
            addSubview(self.ibViewContainer)
            
            self.style(parentView: rootView)
        }
    }
    
    // MARK: Private Methods
    
    private func style(parentView: UIView) {
        isHidden = true
        
        self.ibMessageLabel.numberOfLines = 0
        self.ibMessageLabel.lineBreakMode = .byWordWrapping
        self.textAlignment = .center
        self.textColor = .white
        self.color = OfflineBannerView.defaultColor.hexStringToUIColor()
        self.font = OfflineBannerView.defaultFont
        
        if self.isIPhoneX {
            self.ibViewContainer.layer.cornerRadius = OfflineBannerView.defaultCornerRadius
            self.startY = UIApplication.shared.statusBarFrame.height
        }
        
        let parentViewFrame = CGRect(x: 0, y: -self.height, width: parentView.frame.width, height: self.height)
        frame = parentViewFrame
        parentView.addSubview(self)
    }
    
    private func updateViewHeight() {
        if let text = self.ibMessageLabel.text {
            self.height = text.height(withConstrainedWidth: self.ibViewContainer.frame.width, font: self.font) + 10
            
            let labelFrame = self.ibMessageLabel.frame
            let newlabelFrame = CGRect(x: labelFrame.origin.x, y: labelFrame.origin.y, width: labelFrame.width, height: self.height)
            
            let containerFrame = self.ibViewContainer.frame
            let newContainerFrame = CGRect(x: containerFrame.origin.x, y: containerFrame.origin.y, width: containerFrame.width, height: self.height)
            
            self.ibMessageLabel.frame = newlabelFrame
            self.ibViewContainer.frame = newContainerFrame
        }
    }
    
    private func hide() {
        if !isHidden {
            let newFrame = CGRect(x: 0, y: -frame.height, width: frame.width, height: frame.height)
            UIView.animate(withDuration: self.animationDuration, animations: {
                self.frame = newFrame
            }, completion: { [weak self] _ in
                if !(self?.isIPhoneX ?? false) {
                    UIApplication.shared.delegate?.window??.windowLevel = UIWindowLevelNormal
                }
                self?.isHidden = true
            })
        }
    }
    
    // MARK: Public Methods
    
    public final func show(title: String? = nil) {
        if isHidden {
            
            if let text = title {
                self.text = text
            }
            
            isHidden = false
            let newFrame = CGRect(x: 0, y: self.startY, width: frame.width, height: frame.height)
            
            if !self.isIPhoneX {
                UIApplication.shared.delegate?.window??.windowLevel = UIWindowLevelStatusBar + 1
            }
            UIView.animate(withDuration: self.animationDuration, animations: {
                self.frame = newFrame
                
                let when = DispatchTime.now() + 3
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.hide()
                }
            })
        }
    }
}
