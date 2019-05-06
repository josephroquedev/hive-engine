//
//  PerftTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-05-02.
//

import XCTest
@testable import HiveEngine

private extension Movement {
	var simplified: Movement {
		switch self {
		case .move, .pass, .place: return self
		case .yoink(_, let unit, let to): return .move(unit: unit, to: to)
		}
	}
}

class PerftTests: HiveEngineTestCase {

	/// Values from https://github.com/jonthysell/Mzinga/wiki/Perft
	/// Notes:
	/// 1. The Queen Bee cannot be played on a player's first turn
	/// 2. If a player has multiple bugs of the same type in their hand, then only one is used to calculate the number of valid placements. Ie. if you have two ants in your hand, and five open positions to place a bug, you have five valid moves, not ten.
	/// 3. A player can only Pass if there are no other legal moves, and then that Pass counts as one move for the purposes of calculating perft.
	private let perftTable: [String: [Int]] = [
		"": [4, 96, 1440, 21600, 516240, 12219480],
		"M": [5, 150, 2610, 45414, 1252800, 34233432],
		"L": [5, 150, 2610, 45414, 1252800, 34233672],
		"P": [5, 150, 2610, 45414, 1255932, 34395984],
		"ML": [6, 216, 4320, 86400, 2725920, 85201200],
		"MP": [6, 216, 4320, 86400, 2730888, 85492248],
		"LP": [6, 216, 4320, 86400, 2730240, 85457136],
		"MLP": [7, 294, 6678, 151686, 5427108, 192353904]
	]

	/// Count the number of valid states at a certain depth by iterating all possible moves.
	private func perft(state: GameState, depth: Int) -> Int {
		guard state.move < depth else {
			return Set(state.availableMoves.map { $0.simplified }).count
		}

		var perftCount = 0
		for move in state.availableMoves {
			heartbeat()

			state.apply(move)
			perftCount += perft(state: state, depth: depth)
			state.undoMove()
		}
		return perftCount
	}

	private var lastHeartBeat: DispatchTime = DispatchTime.now()

	/// CI times out afte 10 minutes with no output, so this heartbeat function
	/// prints to STDOUT every 5 minutes to prevent timeout.
	private func heartbeat() {
		let currentTime = DispatchTime.now()
		let secondsSinceLastHeartBeat = Double(currentTime.uptimeNanoseconds - lastHeartBeat.uptimeNanoseconds) / 1_000_000_000
		if secondsSinceLastHeartBeat > 300 {
			print("Heartbeat...")
			lastHeartBeat = currentTime
		}
	}

	func testPerftValidation_BaseGame() {
		let state = GameState(options: [.noFirstMoveQueen, .disableMovementValidation])
		let perftReference = perftTable[""]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	func testPerftValidation_Mosquito() {
		let state = GameState(options: [.noFirstMoveQueen, .disableMovementValidation, .mosquito])
		let perftReference = perftTable["M"]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	func testPerftValidation_LadyBug() {
		let state = GameState(options: [.noFirstMoveQueen, .disableMovementValidation, .ladyBug])
		let perftReference = perftTable["L"]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	func testPerftValidation_PillBug() {
		let state = GameState(options: [.noFirstMoveQueen, .disableMovementValidation, .pillBug])
		let perftReference = perftTable["P"]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	func testPerftValidation_Mosquito_LadyBug() {
		let state = GameState(options: [.noFirstMoveQueen, .disableMovementValidation, .mosquito, .ladyBug])
		let perftReference = perftTable["ML"]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	func testPerftValidation_Mosquito_PillBug() {
		let state = GameState(options: [.noFirstMoveQueen, .disableMovementValidation, .mosquito, .pillBug])
		let perftReference = perftTable["MP"]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	func testPerftValidation_LadyBug_PillBug() {
		let state = GameState(options: [.noFirstMoveQueen, .disableMovementValidation, .ladyBug, .pillBug])
		let perftReference = perftTable["LP"]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	func testPerftValidation_Mosquito_LadyBug_PillBug() {
		let state = GameState(options: [.noFirstMoveQueen, .disableMovementValidation, .mosquito, .ladyBug, .pillBug])
		let perftReference = perftTable["MLP"]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	static var allTests: [(String, ((PerftTests) -> Void) -> Void)] = [
//		("testPerftValidation_BaseGame", testPerftValidation_BaseGame),
//		("testPerftValidation_Mosquito", testPerftValidation_Mosquito),
//		("testPerftValidation_LadyBug", testPerftValidation_LadyBug),
//		("testPerftValidation_PillBug", testPerftValidation_PillBug),
//		("testPerftValidation_Mosquito_LadyBug", testPerftValidation_Mosquito_LadyBug),
//		("testPerftValidation_Mosquito_PillBug", testPerftValidation_Mosquito_PillBug),
//		("testPerftValidation_LadyBug_PillBug", testPerftValidation_LadyBug_PillBug),
//		("testPerftValidation_Mosquito_LadyBug_PillBug", testPerftValidation_Mosquito_LadyBug_PillBug)
	]
}
