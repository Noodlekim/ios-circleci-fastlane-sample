//
//  MainView.swift
//  TCA_Sample
//
//  Created by NoodleKim on 2026/01/08.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    var body: some View {
        UserSearchView(store: .init(initialState: .init(), reducer: {
            UserSearchFeature()
        }))
    }
}

#Preview {
    MainView()
}
