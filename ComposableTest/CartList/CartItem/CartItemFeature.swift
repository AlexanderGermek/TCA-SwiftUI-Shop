//
//  CartItemFeature.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 01.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct CartItemFeature: Reducer {
  
  struct State: Equatable, Identifiable {
    let id: UUID
    let cartItem: CartItem
  }

  enum Action: Equatable {}

  func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action> {
    return .none
  }
}
