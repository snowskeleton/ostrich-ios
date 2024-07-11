// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension Gamestateschema {
  /// The pairing method of an event is used to determine how players are paired
  /// against each other (except for "player list only", since we do not perform
  /// any pairings at all in that case).
  enum PairingType: String, EnumType {
    /// pairing__swiss
    case swiss = "SWISS"
    /// pairing__single-elimination
    case singleElimination = "SINGLE_ELIMINATION"
    /// pairing__player-list-only
    case playerListOnly = "PLAYER_LIST_ONLY"
    /// pairing__queued
    case queued = "QUEUED"
  }

}