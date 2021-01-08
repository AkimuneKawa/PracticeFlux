//
//  ActionCreator.swift
//  PracticeFlux
//
//  Created by 河明宗 on 2021/01/08.
//  Copyright © 2021 河明宗. All rights reserved.
//

import Foundation
import GitHub

enum Action {
    case addRepositories([Repository])
    case clearRepositories
}
