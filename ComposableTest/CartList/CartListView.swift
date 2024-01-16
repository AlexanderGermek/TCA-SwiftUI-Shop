//
//  CartListView.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 25.10.2023.
//

import SwiftUI
import ComposableArchitecture

struct CartListView: View {
  let store: Store<CartListFeature.State, CartListFeature.Action>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      NavigationStack {
        List {
          ForEachStore(
            self.store.scope(
              state: \.cartItems,
              action: CartListFeature.Action.cartItem(id: action:)
            )) { store in
              CartItemView(store: store)
            }
        }
        .navigationTitle("Cart")
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button {
              viewStore.send(.didPressCloseButton)
            } label: {
              Text("Close")
            }
          }
        }
      }
    }
  }
}

struct CartListView_Previews: PreviewProvider {
  static var previews: some View {
    CartListView(store: .init(
      initialState: CartListFeature.State(
        cartItems: IdentifiedArrayOf(
          uniqueElements: CartItem.sample.map {
          CartItemFeature.State(id: UUID(), cartItem: $0)
        }))
    ) {
      CartListFeature()
    })
  }
}
