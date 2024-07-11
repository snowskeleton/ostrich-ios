// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class TimerUpdatedSubscription: GraphQLSubscription {
    static let operationName: String = "timerUpdated"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"subscription timerUpdated($id: ID!) { timerUpdated(id: $id) { ...TimerDetails __typename } }"#,
        fragments: [TimerDetails.self]
      ))

    public var id: ID

    public init(id: ID) {
      self.id = id
    }

    public var __variables: Variables? { ["id": id] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Subscription }
      static var __selections: [ApolloAPI.Selection] { [
        .field("timerUpdated", TimerUpdated.self, arguments: ["id": .variable("id")]),
      ] }

      var timerUpdated: TimerUpdated { __data["timerUpdated"] }

      /// TimerUpdated
      ///
      /// Parent Type: `Timer`
      struct TimerUpdated: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Timer }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(TimerDetails.self),
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

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var timerDetails: TimerDetails { _toFragment() }
        }
      }
    }
  }

}