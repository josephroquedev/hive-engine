//
//  RelativeMovement.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-05-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

public struct RelativeMovement {
	/// The unit that was moved in the Movement
	public let movedUnit: Unit
	/// A `Unit` that `movedUnit` is adjacent to, and the direction `movedUnit` is in, relative to that unit.
	/// `nil` in the case there is no adjacent unit.
	public let adjacent: (unit: Unit, direction: Direction)?

	public init(unit: Unit, adjacentTo adjacent: (unit: Unit, direction: Direction)?) {
		self.movedUnit = unit
		self.adjacent = adjacent
	}

	/// Standard notation for the movement.
	/// See http://www.boardspace.net/english/about_hive_notation.html for a description of the notation
	public var notation: String {
		var notation = movedUnit.notation
		if let adjacent = adjacent {
			switch adjacent.direction {
			case .onTop:
				notation += " \(adjacent.unit.notation)"
			case .north, .northWest, .southWest:
				notation += " \(adjacent.direction.notation)\(adjacent.unit.notation)"
			case .northEast, .southEast, .south:
				notation += " \(adjacent.unit.notation)\(adjacent.direction.notation)"
			}
		}
		return notation
	}
}

extension RelativeMovement: CustomStringConvertible {
	public var description: String {
		if let adjacent = adjacent {
			return "Move \(movedUnit) \(adjacent.direction) of \(adjacent.unit)"
		} else {
			return "Place \(movedUnit) at origin"
		}
	}
}