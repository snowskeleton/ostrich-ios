// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension Gamestateschema {
  enum EventStatus: String, EnumType {
    /// The default, initial state of a newly-created event: scheduled but not yet active
    case scheduled = "SCHEDULED"
    /// At least one player has been registered but the event has not yet been paired
    case playerregistration = "PLAYERREGISTRATION"
    /// Player registration is complete and the first round is ready, with pairings.
    /// Note that this status is not used in a Draft tournament, which has its own
    /// pre-round states.
    case roundready = "ROUNDREADY"
    /// Player registration is complete and the players have been assigned to draft pods.
    case drafting = "DRAFTING"
    /// Drafting is complete and players are expected to construct their limited deck.
    case deckconstruction = "DECKCONSTRUCTION"
    /// A round of the event is currently being played. (You can check the currentRound of
    /// the Event object to find out which round it is.)
    case roundactive = "ROUNDACTIVE"
    /// All scores for the most recently played round have been recorded and certified, but the
    /// next round (if any) has not yet begun. Pairings for the next round, if any, are available.
    case roundcertified = "ROUNDCERTIFIED"
    /// The event has ended normally.
    case ended = "ENDED"
    /// The event was cancelled before play completed.
    case cancelled = "CANCELLED"
    /// The event did not start within 7 days of its scheduled start time and has been expired.
    case expired = "EXPIRED"
    /// (Deprecated) the event is currently active. Replaced by DRAFTING, DECK_CONSTRUCTION,
    /// ROUND_READY, ROUND_ACTIVE, and ROUND_CERTIFIED.
    ///
    /// **Deprecated**: Unused and replaced with the states above. EoL: 04-30-23
    case running = "RUNNING"
  }

}