//
//  UserProfileView.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 22.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct UserProfileView: View {

	let store: StoreOf<UserProfileDomain>

	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			NavigationStack {
				Form {
					Section {
						Text(viewStore.fullName.capitalized)
					} header: {
						Text("Full name")
					}

					Section {
						Text(viewStore.profileState.email)
					} header: {
						Text("Email")
					}
				}
				.task {
					viewStore.send(.loadUserProfile)
				}
				.navigationTitle("Profile")
			}
		}
	}
}

#Preview {
	UserProfileView(store: .init(
		initialState: UserProfileDomain.State()
	) {
		UserProfileDomain()
	})
}
