//
//  GameString.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-12.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Regex

struct GameString {
	let state: GameState

	init?(from: String) {
		let components = from.split(separator: ";")

		guard let state = GameTypeString(from: String(components[0]))?.state,
			let stateString = GameStateString(rawValue: String(components[1])) else {
			return nil
		}

		guard stateString != .notStarted else {
			self.state = state
			return
		}

		for move in components.dropFirst(3) {
			guard let moveString = MoveString(from: String(move)) else {
				return nil
			}

			let oldMove = state.move
			state.apply(relativeMovement: moveString.movement)
			guard state.move > oldMove else {
				return nil
			}
		}

		guard let turnString = TurnString(from: String(components[2])),
			turnString.turn == (state.move / 2) + 1  else {
			return nil
		}

		self.state = state
	}
}