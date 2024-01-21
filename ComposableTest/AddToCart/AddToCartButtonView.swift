//
//  AddToCartButtonView.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 20.10.2023.
//

import ComposableArchitecture
import SwiftUI

struct AddToCartButtonView: View {
	
	let store: StoreOf<AddToCartFeature>
	
	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			if viewStore.count > 0 {
				PlusMinusButton(store: self.store)
			} else {
				Button {
					viewStore.send(.didTapPlusButton)
				} label: {
					Text("Add to Cart")
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

// MARK: - AddToCartButtonView_Preview
struct AddToCartButtonView_Preview: PreviewProvider {
	static var previews: some View {
		AddToCartButtonView(store: .init(initialState: AddToCartFeature.State()) {
			return AddToCartFeature()
		})
	}
}
