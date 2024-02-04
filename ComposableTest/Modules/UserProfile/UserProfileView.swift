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
				if viewStore.isLoading {
					ProgressView()
						.scaleEffect(3)
						.frame(width: 200, height: 200)
				} else {
					if viewStore.profileState == .default {
						ErrorView(
							title: "Error",
							subtitle: "Oops, fetch user info is failed!") {
								viewStore.send(.loadUserProfile)
							}
					} else {
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
						.navigationTitle("Profile")
					}
				}
			}
			.onViewDidLoad {
				viewStore.send(.loadUserProfile)
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
