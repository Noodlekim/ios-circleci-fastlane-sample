//
//  UserRow.swift
//  TCA_Sample
//
//  Created by NoodleKim on 2026/01/08.
//

import SwiftUI

struct UserRow: View {
    let user: UserEntity
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                AsyncImage(url: URL(string: user.avatarUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .clipShape(Circle())
                .frame(width: 50, height: 50)
                .padding()
                Text(user.login)
                    .padding()
                Spacer()
            }
        }
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        UserRow(user: UserEntity.mock, onTap: {})
    }
}
