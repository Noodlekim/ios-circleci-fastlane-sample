//
//  UserSearchView.swift
//  TCA_Sample
//
//  Created by NoodleKim on 2026/01/08.
//

import ComposableArchitecture
import SwiftUI

struct UserSearchView: View {
    @Bindable var store: StoreOf<UserSearchFeature>

    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            VStack {
                switch store.loadState {
                case .initial, .loading:
                    ProgressView()
                case .loaded(let users):
                    VStack {
                        TextField("GitHubのユーザー名を入れてください", text: $store.searchText)
                        // TODO: onChange(of:) 使わずbinding処理を
                            .onChange(of: store.state.searchText, { old, new in
                                store.send(.searchUsers(new))
                            })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.asciiCapable)
                            .padding()
                        Spacer()
                        List(users) { user in
                            UserRow(user: user) {
                                store.send(.onTapUserRow(user))
                            }
                        }
                        .refreshable {
                            Task {
                                store.send(.pullToRefresh)
                            }
                        }
                        Spacer()
                    }
                case .failed(let error):
                    Text(error.localizedDescription)
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
        } destination: { store in
            RepositoryView(store: store)
        }
    }
}

struct UsersSearchView_Previews: PreviewProvider {
    static var previews: some View {
        UserSearchView(store: .init(initialState: .init(), reducer: {
            UserSearchFeature()
        }))
    }
}
