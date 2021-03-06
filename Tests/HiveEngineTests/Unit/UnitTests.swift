//
//  UnitTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-16.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import HiveEngineTestUtilities
import XCTest
@testable import HiveEngine

final class UnitTests: HiveEngineTestCase {

	// MARK: - Unit

	func testWhenSurrounded_IsSurrounded_IsTrue() {
		let state = stateProvider.wonGameState
		XCTAssertTrue(state.whiteQueen.isSurrounded(in: state))
	}

	func testWhenNotSurrounded_IsSurrounded_IsFalse() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin),
			]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertFalse(state.whiteQueen.isSurrounded(in: state))
	}

	func testWhenTopOfStack_IsTopOfStack_IsTrue() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertTrue(state.whiteBeetle.isTopOfStack(in: state))
	}

	func testWhenBottomOfStack_IsTopOfStack_IsFalse() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin),
			]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertFalse(state.whiteQueen.isTopOfStack(in: state))
	}

	func testWhenNotInPlay_IsTopOfStack_IsFalse() {
		let state = stateProvider.initialGameState
		XCTAssertFalse(state.whiteAnt.isTopOfStack(in: state))
	}

	func testStackPosition_IsCorrect() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin),
			]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertEqual(2, state.whiteBeetle.stackPosition(in: state))
		XCTAssertEqual(1, state.whiteQueen.stackPosition(in: state))
	}

	func testWhenNotInPlay_StackPosition_IsNil() {
		let state = stateProvider.initialGameState
		XCTAssertNil(state.whiteAnt.stackPosition(in: state))
	}

	func testWhenTopOfStackNotOneHive_CanMove_IsFalse() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin),
			]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertTrue(state.blackQueen.isTopOfStack(in: state))
		XCTAssertFalse(state.oneHive(excluding: state.blackQueen))
		XCTAssertFalse(state.blackQueen.canMove(in: state))
	}

	func testWhenBottomOfStackOneHive_CanMove_IsFalse() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin),
			]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertFalse(state.whiteQueen.isTopOfStack(in: state))
		XCTAssertTrue(state.oneHive(excluding: state.whiteQueen))
		XCTAssertFalse(state.whiteQueen.canMove(in: state))
	}

	func testWhenTopOfStackOneHive_CanMove_IsTrue() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin),
			]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertTrue(state.blackBeetle.isTopOfStack(in: state))
		XCTAssertTrue(state.oneHive(excluding: state.blackBeetle))
		XCTAssertTrue(state.blackBeetle.canMove(in: state))
	}

	func testUnitDescription_IsCorrect() {
		let state = stateProvider.initialGameState
		XCTAssertEqual("Black Ant (1)", state.blackAnt.description)
		XCTAssertEqual("White Beetle (1)", state.whiteBeetle.description)
	}

	func testUnitNotation_IsCorrect() {
		let state = stateProvider.initialGameState
		XCTAssertEqual("bA1", state.blackAnt.notation)
		XCTAssertEqual("wS2", HiveEngine.Unit(class: .spider, owner: .white, index: 2).notation)
		XCTAssertEqual("wP", HiveEngine.Unit(class: .pillBug, owner: .white, index: 1).notation)
	}

	func testUnitFromNotation() {
		let state = stateProvider.initialGameState
		XCTAssertEqual(state.blackAnt, HiveEngine.Unit(notation: "bA1"))
		XCTAssertEqual(state.whiteQueen, HiveEngine.Unit(notation: "wQ"))
	}

	func testUnitComparable_IsCorrect() {
		// 1 before 2
		XCTAssertTrue(Unit(class: .ant, owner: .white, index: 1) < Unit(class: .ant, owner: .white, index: 2))
		// Ant before Beetle
		XCTAssertTrue(Unit(class: .ant, owner: .white, index: 1) < Unit(class: .beetle, owner: .white, index: 1))
		// White before black
		XCTAssertTrue(Unit(class: .ant, owner: .white, index: 1) < Unit(class: .ant, owner: .black, index: 1))
	}
}
