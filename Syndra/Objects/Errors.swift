//
//  Errors.swift
//  Syndra
//
//  Created by Mason Phillips on 7/19/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

enum GamesVerificationError: Error {
    // When checking data
    case SeasonNotMatch
    case SplitNotMatch
    case WeekCountNotMatch
    case DayCountNotMatch
    case GameCountNotMatch
}

enum SyndraCast: Error {
    // Objects
    case CastBackSeason
    case CastBackSplit
    case CastBackWeek
    case CastBackDay
    case CastBackGame
    case CastBackTeam
    
    // Misc
    case CastBackViewController
}
