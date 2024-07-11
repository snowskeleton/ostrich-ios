// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct QueueDetails: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment QueueDetails on Queue { __typename queueId eventId name description groupSize isGlobal queueSize players }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Queue }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("queueId", Gamestateschema.ID.self),
      .field("eventId", Gamestateschema.ID.self),
      .field("name", String.self),
      .field("description", String?.self),
      .field("groupSize", Int.self),
      .field("isGlobal", Bool.self),
      .field("queueSize", Int.self),
      .field("players", [String]?.self),
    ] }

    /// The primary identifier for the queue
    var queueId: Gamestateschema.ID { __data["queueId"] }
    /// The event the queue is a part of
    var eventId: Gamestateschema.ID { __data["eventId"] }
    /// The name of the queue.
    var name: String { __data["name"] }
    /// The description of the queue.
    var description: String? { __data["description"] }
    /// The number of players required to fire the queue.
    var groupSize: Int { __data["groupSize"] }
    /// Determines if the queue operates like a global queue.
    var isGlobal: Bool { __data["isGlobal"] }
    /// The number of players currently in the queue.
    var queueSize: Int { __data["queueSize"] }
    /// The persona Ids of players currently in the queue.
    var players: [String]? { __data["players"] }
  }

}