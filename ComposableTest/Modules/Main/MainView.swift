//
//  MainView.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 22.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {

	let store: StoreOf<MainDomain>

	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			TabView(
				selection: viewStore.binding(
					get: \.currentTab,
					send: MainDomain.Action.tabSelected),
				content: {
					ProductListView(store: self.store.scope(
						state: \.productListState,
						action: MainDomain.Action.productList)
					)
					.tabItem {
						Image(systemName: "list.bullet")
						Text("Products")
					}
					.tag(MainDomain.State.Tab.products)

					UserProfileView(store: self.store.scope(
						state: \.profileState,
						action: MainDomain.Action.userProfile)
					)
					.tabItem {
						Image(systemName: "person.fill")
						Text("Profile")
					}
					.tag(MainDomain.State.Tab.profile)
				})
		}
	}
}

#Preview {
	MainView(store: .init(
		initialState: MainDomain.State()
	) {
		MainDomain()
	})
}
