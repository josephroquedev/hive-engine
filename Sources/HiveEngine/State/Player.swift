//
//  Player.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

/// Players of the game
public enum Player: String, Codable {
	/// The first player, white
	case white = "White"
	/// The second player, black
	case black = "Black"

	/// Returns the next player
	public var next: Player {
		switch self {
		case .black: return .white
		case .white: return .black
		}
	}
}

// MARK: - CustomStringConvertible

extension Player: CustomStringConvertible {
	public var description: String {
		return self.rawValue
	}
}

// MARK: - Comparable

extension Player: Comparable {
	public static func < (lhs: Player, rhs: Player) -> Bool {
		switch (lhs, rhs) {
		case (.white, .black): return true
		default: return false
		}
	}
}
