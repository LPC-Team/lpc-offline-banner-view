//
//  DeviceHelper.swift
//  LPCOfflineBannerView
//
//  Created by Alaeddine Ouertani on 15/02/2018.
//  Copyright © 2018 Lakooz. All rights reserved.
//

import UIKit

enum DeviceHelper {
    
    static var isIPhoneX: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            return UIScreen.main.nativeBounds.height == 2436
        }
        
        return false
    }
}
