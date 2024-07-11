// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension Gamestateschema {
  /// Determines the way that a Swiss Draft event will create it's pairings. InPod will only create pairings with other players
  /// in the same pod. While CrossPod will create pairings based on all possible pairings with any of the other players in their
  /// own pod or another.
  enum PodPairingTypeV2: String, EnumType {
    /// Pairings will only consider the same pod
    case inPod = "InPod"
    /// Pairings will consider all pods
    case crossPod = "CrossPod"
  }

}