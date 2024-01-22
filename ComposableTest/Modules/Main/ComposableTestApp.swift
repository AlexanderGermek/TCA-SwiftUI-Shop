//
//  ComposableTestApp.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 19.10.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct ComposableTestApp: App {

	private let store = Store(initialState: MainDomain.State()) {
		MainDomain()
	}

	var body: some Scene {
		WindowGroup {
			MainView(store: store)
		}
	}
}
