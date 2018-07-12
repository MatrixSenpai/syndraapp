//
//  DefaultsKeys.swift
//  Syndra
//
//  Created by Mason Phillips on 7/12/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let dataLoaded    = DefaultsKey<Bool>("isDataLoaded")
    static let currentSeason = DefaultsKey<Int>("currentSeason")
    static let currentSplit  = DefaultsKey<Int>("currentSplit")
}
