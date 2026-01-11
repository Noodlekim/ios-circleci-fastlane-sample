//
//  RepositoryView.swift
//  TCA_Sample
//
//  Created by NoodleKim on 2026/01/08.
//

import ComposableArchitecture
import SwiftUI

struct RepositoryView: View {
    @Bindable var store: StoreOf<RepositoryFeature>
    
    var body: some View {
        ScrollView {
            VStack {
                switch store.loadState {
                case .initial, .loading:
                    ProgressView()
                case .loaded(let repositories):
                    ForEach(repositories) { repository in
                        RepositoryRow(repository: repository)
                    }
                case .failed(let error):
                    Text(error.localizedDescription)
                }
            }
        }
        .frame(width: 500, height: 600)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryView(store: .init(initialState: .init(reposUrl: ""), reducer: {
            RepositoryFeature()
        }))
    }
}
