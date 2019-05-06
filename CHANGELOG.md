## 2.0.0

* Added a new `.pass` Movement for players who become shut out and unable to make any other moves
* `lastMovedUnit` and `lastMovedPlayer` added as convenience accessors
* `availableMoves` is cached after its first calculation, for improved performance. It is cleared when a move is applied or undone
* 3 new `GameState.Options`:
    * `restrictedOpening`: limits `Black`'s first move to a single position, to reduce branching
    * `noFirstMoveQueen`: optional rule, prevents either play from playing their Queen as their first piece
    * `allowSpecialAbilityAfterYoink`: enable using the Pill Bug's ability immediately after the ability has been used on it.
* Passing [perft tests](https://github.com/jonthysell/Mzinga/wiki/Perft)

### Breaking changes
* Removed `requireMovementValidation` accessor, replaced by `GameState.Options.disableMovementValidation`
* Renamed `moves(as:in:)` to `canCopyMoves(of:in)` to reduce ambiguity with method bearing a similar name
* Removed `opponentMoves` due to the additional complexity required to maintain its functionality
* A shut out player is no longer skipped. Instead, they have only 1 available move, `.pass`, and must play it

## 1.2.0

* Add support for [standard Hive notation](http://www.boardspace.net/english/about_hive_notation.html)
* Limit the pieces playable from hand to be only the unit of each class with the lowest index. For example, with 3 ants with indices 1, 2, and 3, only the ant with index 1 can be placed. After it is placed, only the ant with index 2 can be placed, etc.

## 1.1.0

* Human readable encodings for Movements for ease of debugging.

## 1.0.0

* With the release and support of Swift 5.0, the engine now appears stable.
* The Hive Engine version 1.0 is capable of tracking the state of a game of Hive with the 3 official expansions included.