// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct TimerDetails: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment TimerDetails on Timer { __typename id state durationMs durationStartTime serverTime }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Timer }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", Gamestateschema.ID.self),
      .field("state", GraphQLEnum<Gamestateschema.TimerState>.self),
      .field("durationMs", Int.self),
      .field("durationStartTime", Gamestateschema.DateTime.self),
      .field("serverTime", Gamestateschema.DateTime.self),
    ] }

    /// The ID of the timer.
    var id: Gamestateschema.ID { __data["id"] }
    /// The state of the timer; whether it's running or halted.
    var state: GraphQLEnum<Gamestateschema.TimerState> { __data["state"] }
    /// The length of the timer, in milliseconds. 'null' if the timer is DELETED.
    var durationMs: Int { __data["durationMs"] }
    /// The time that the duration of the timer begins. 'null' if the timer is DELETED.
    var durationStartTime: Gamestateschema.DateTime { __data["durationStartTime"] }
    /// The current time at the server. Allows computation of timer skew. 'null' if the timer is DELETED.
    var serverTime: Gamestateschema.DateTime { __data["serverTime"] }
  }

}