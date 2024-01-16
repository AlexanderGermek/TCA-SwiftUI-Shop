//
//  CartListFeature.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 01.11.2023.
//

import ComposableArchitecture

struct CartListFeature: Reducer {

  struct State: Equatable {
    var cartItems: IdentifiedArrayOf<CartItemFeature.State> = []
  }

  // MARK: - Action
  enum Action: Equatable {
    case didPressCloseButton
    case cartItem(id: CartItemFeature.State.ID, action: CartItemFeature.Action)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {

      case .didPressCloseButton:
        return .none
      case .cartItem:
        return .none
      }

    }
    .forEach(\.cartItems, action: /Action.cartItem(id:action:)) {
      CartItemFeature()
    }
  }
}
