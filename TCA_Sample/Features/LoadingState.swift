//
//  LoadingState.swift
//  TCA_Sample
//
//  Created by NoodleKim on 2026/01/08.
//

import ComposableArchitecture
import Foundation

enum LoadingState<State: Equatable> {
    /// 初期状態
    case initial
    /// ローディング時
    case loading
    /// ロード完了時
    case loaded(State)
    /// エラー時
    case failed(Error)
}

extension LoadingState: Equatable {
    static func == (lhs: LoadingState<State>, rhs: LoadingState<State>) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial),
             (.loading, .loading):
            return true
        case let (.loaded(lhs), .loaded(rhs)):
            return lhs == rhs
        case let (.failed(lhs), .failed(rhs)):
            return lhs.localizedDescription == rhs.localizedDescription
        default:
            return false
        }
    }
}
