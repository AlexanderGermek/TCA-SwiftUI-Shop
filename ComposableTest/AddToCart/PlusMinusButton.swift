//
//  ContentView.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 19.10.2023.
//

import SwiftUI
import ComposableArchitecture

struct PlusMinusButton: View {
	let store: StoreOf<AddToCartFeature>

	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			HStack {
				Button {
					viewStore.send(.didTapMinusButton)
				} label: {
					Text("-")
						.padding(10)
						.background(.blue)
						.foregroundColor(.white)
						.cornerRadius(10)
				}
				.buttonStyle(.plain)

				Text(viewStore.count.description)
					.padding(5)

				Button {
					viewStore.send(.didTapPlusButton)
				} label: {
					Text("+")
						.padding(10)
						.background(.blue)
						.foregroundColor(.white)
						.cornerRadius(10)
				}
				.buttonStyle(.plain)
			}
		}
	}
}

struct PlusMinusButton_Previews: PreviewProvider {
	static var previews: some View {
		PlusMinusButton(store: .init(initialState: AddToCartFeature.State()) {
			return AddToCartFeature()
		})
	}
}
