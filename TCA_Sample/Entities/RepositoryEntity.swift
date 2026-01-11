//
//  RepositoryEntity.swift
//  TCA_Sample
//
//  Created by NoodleKim on 2026/01/08.
//

import Foundation

/// GithubのAPIが返すリポジトリのデータ。必要なプロパティのみを取得する
public struct RepositoryEntity: Codable, Identifiable, Equatable, Sendable {
    public let id = UUID()
    public let name: String
    public let htmlUrl: String
    public let description: String?
    public let language: String?
    public let stargazersCount: Int
    public let forksCount: Int

    private enum CodingKeys: String, CodingKey, Sendable {
        case name
        case htmlUrl
        case description
        case language
        case stargazersCount
        case forksCount
    }

    public static let mock = RepositoryEntity(name: "iOS-architecture-training",
                                 htmlUrl: "https://github.com/0si43/iOS-architecture-training",
                                 description: "iOSアプリのアーキテクチャーの勉強用のリポジトリです",
                                 language: "Swift",
                                 stargazersCount: 1000,
                                 forksCount: 100)
}
