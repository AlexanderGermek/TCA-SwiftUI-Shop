//
//  CartListView.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 25.10.2023.
//

import SwiftUI
import ComposableArchitecture

struct CartListView: View {
  let store: StoreOf<CartListDomain>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      NavigationStack {
        List {
          ForEachStore(
            self.store.scope(
              state: \.cartItems,
              action: CartListDomain.Action.cartItem(id: action:)
            )) {
              CartItemView(store: $0)
                .buttonStyle(PlainButtonStyle())
            }
        }
        .onAppear {
          viewStore.send(.setTotalPrice)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                viewStore.send(.didTapPayButton)
            } label: {
                HStack(alignment: .center) {
                    Spacer()
                  Text("Pay $\(viewStore.totalPrice.formattedWithSeparator)")
                        .font(.custom("AmericanTypewriter", size: 30))
                        .foregroundColor(.white)

                    Spacer()
                }

            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(viewStore.isPayButtonDisable ? .gray : .blue)
            .cornerRadius(10)
            .padding()
            .disabled(viewStore.isPayButtonDisable)
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
      initialState: CartListDomain.State(
        cartItems: IdentifiedArrayOf(
          uniqueElements: CartItem.sample.map {
          CartItemDomain.State(id: UUID(), cartItem: $0)
        }))
    ) {
      CartListDomain()
    })
  }
}