// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class GetTimerQuery: GraphQLQuery {
    static let operationName: String = "getTimer"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query getTimer($id: ID!) { timer(id: $id) { ...TimerDetails __typename } }"#,
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

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("timer", Timer.self, arguments: ["id": .variable("id")]),
      ] }

      /// Query to fetch a timer by ID.
      var timer: Timer { __data["timer"] }

      /// Timer
      ///
      /// Parent Type: `Timer`
      struct Timer: Gamestateschema.SelectionSet {
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