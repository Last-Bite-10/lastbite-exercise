//
//  HomeViewModel.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 27/10/25.
//

import SwiftUI

@Observable class HomeViewModel {
    var firstLaunch: Bool = true
    var currentView: ViewState = .questionnaire
}

enum ViewState {
    case questionnaire
    case home
}
