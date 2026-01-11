//
//  GitHubRepository.swift
//  TCA_Sample
//
//  Created by NoodleKim on 2026/01/08.
//

import Foundation

protocol RepositoryProtocol {
    var endpoint: URLComponents { get }
    func userSearchEndpoint(query: String) -> URL?
    @MainActor
    func fetch(url: URL) async -> Result<Data, Error>
}

struct GitHubRepository: RepositoryProtocol {
    public var endpoint: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        return components
    }
    
    func userSearchEndpoint(query: String) -> URL? {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return nil
        }

        var urlComponents = endpoint
        urlComponents.path = "/search/users"
        urlComponents.queryItems = [URLQueryItem(name: "q", value: encodedQuery)]
        guard let url = urlComponents.url else {
            return nil
        }

        return url
    }

    @MainActor
    func fetch(url: URL) async -> Result<Data, Error> {
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            return .success(data)
        } catch {
            return .failure(error)
        }
    }

}


/// GitHubAPIError
public enum GitHubAPIError: Error, Equatable {
    public static func == (lhs: GitHubAPIError, rhs: GitHubAPIError) -> Bool {
        switch (lhs, rhs) {
        case (.urlError, .urlError):
            return true
        case (.responseError(let lhsError), .responseError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.responseDataEmpty, .responseDataEmpty):
            return true
        case (.jsonParseError(let lhsErrorMessage), .jsonParseError(let rhsErrorMessage)):
            return lhsErrorMessage == rhsErrorMessage
        default:
            return false
        }
    }
    /// URLエラー
    case urlError
    /// レスポンスエラー
    case responseError(Error)
    /// レスポンスデータ空
    case responseDataEmpty
    /// JSONパーシング失敗
    case jsonParseError(String)

    public var localizedDescription: String {
        switch self {
        case .urlError: return "URLに変換しようとしたところで失敗しました"
        case .responseError(let error): return "API叩いたらエラーが返ってきました。詳細: （\(error)）"
        case .responseDataEmpty: return "APIから取得したデータがnilでした"
        case .jsonParseError(let message): return "JSONのパースに失敗しました。失敗したデータ: (\(message)"
        }
    }
}
