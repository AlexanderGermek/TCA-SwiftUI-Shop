//
//  CartListDomain.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 01.11.2023.
//

import Foundation
import ComposableArchitecture

struct CartListDomain: Reducer {
  
  // MARK: - State
  struct State: Equatable {
    var cartItems: IdentifiedArrayOf<CartItemDomain.State> = []
    var totalPrice: Decimal = 0
    var isPayButtonDisable = false
  }

  // MARK: - Action
  enum Action: Equatable {
    case didPressCloseButton
    case cartItem(id: CartItemDomain.State.ID, action: CartItemDomain.Action)
    case setTotalPrice
    case didTapPayButton
    case didReceivePurchaseResponse(TaskResult<String>)
  }

    let sendOrder: ([CartItem]) async throws -> String

  // MARK: - Reducer
  var body: some Reducer<State, Action> {
    Reduce { state, action in

      switch action {

      case .cartItem(_, let action):

        switch action {

        case .deleteCartItem(let product):

          if let cartItemIndex = state.cartItems.map({ $0.cartItem }).firstIndex(where: {
            $0.product.id == product.id
          }) {
            state.cartItems.remove(at: cartItemIndex)
          }
        }

        return .send(.setTotalPrice)

      case .setTotalPrice:

        let items = state.cartItems.map { $0.cartItem }
        state.totalPrice = items.reduce(0, {
          $0 + Decimal($1.quantity) * $1.product.price
        })

        return setDisableForPayButton(state: &state)

      case .didTapPayButton:
        let items = state.cartItems.map { $0.cartItem }

        return .run { send in
          let result = await TaskResult {
            try await sendOrder(items)
          }
          await send(.didReceivePurchaseResponse(result))
        }

      case .didReceivePurchaseResponse(let result):
        switch result {
        case .success(let string): print(string)
        case .failure(let error): print(error.localizedDescription)
        }

      default:
        break
      }

      return .none
    }
    .forEach(\.cartItems, action: /Action.cartItem(id:action:)) {
      CartItemDomain()
    }
  }
  
  // MARK: - Private
  private func setDisableForPayButton(state: inout State) -> Effect<Action> {
    state.isPayButtonDisable = state.cartItems.isEmpty
    return .none
  }
}
