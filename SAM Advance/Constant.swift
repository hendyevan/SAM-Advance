//
//  Constant.swift
//  SAM Advance
//
//  Created by Fabianus Hendy Evan on 1/11/17.
//  Copyright © 2017 Astra International. All rights reserved.
//

import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
let defaults = UserDefaults.standard

//let BASE_URL = "https://astrasam2.azurewebsites.net/"
//let BASE_URL = "https://devproxy.astra.co.id/astrasamutt/"
let BASE_URL = "https://devproxy.astra.co.id/astrasam/"

//PROD
//let BASE_URL = "https://astraapps.astra.co.id/astrasam/"

//
let linkUrlKey = "link_url"
let devicePushTokenKey = "DevicePushToken"
