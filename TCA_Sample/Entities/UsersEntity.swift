//
//  UsersEntity.swift
//  TCA_Sample
//
//  Created by NoodleKim on 2026/01/08.
//

import Foundation

/// GithubのAPIが返すユーザーデータ。必要なプロパティのみを取得する
public struct UsersEntity: Codable, Sendable {
    public let totalCount: Int
    public let incompleteResults: Bool
    public let items: [UserEntity]
}

public struct UserEntity: Codable, Identifiable, Equatable, Sendable {
    public let id = UUID()
    public let login: String
    public let avatarUrl: String
    public let reposUrl: String
    public static let mock = UserEntity(login: "gibongkim",
                               avatarUrl: "https://avatars.githubusercontent.com/u/5136313?v=4",
                               reposUrl: "https://api.github.com/users/noodlekim/repos")
}
