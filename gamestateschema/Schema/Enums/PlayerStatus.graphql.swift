// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension Gamestateschema {
  /// Determines the player status in an event. A player can be either Registered if the TO has added them to the event,
  /// Reserved if the player has reserved a spot in the event but is not yet added, Dropped if the player has been dropped
  /// from the event after the event has started, or None if the player is not in the event
  enum PlayerStatus: String, EnumType {
    /// Player has been added to the event by the TO.
    case registered = "Registered"
    /// Player has reserved a place, but is not in the event.
    case reserved = "Reserved"
    /// Player has been dropped from the event.
    case dropped = "Dropped"
    /// Player is not in the event.
    case none = "None"
  }

}