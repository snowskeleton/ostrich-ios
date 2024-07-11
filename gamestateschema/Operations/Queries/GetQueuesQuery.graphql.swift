// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class GetQueuesQuery: GraphQLQuery {
    static let operationName: String = "getQueues"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query getQueues($eventId: ID!) { queues(eventId: $eventId) { ...QueueDetails __typename } }"#,
        fragments: [QueueDetails.self]
      ))

    public var eventId: ID

    public init(eventId: ID) {
      self.eventId = eventId
    }

    public var __variables: Variables? { ["eventId": eventId] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("queues", [Queue].self, arguments: ["eventId": .variable("eventId")]),
      ] }

      /// Get all queues fo an event
      var queues: [Queue] { __data["queues"] }

      /// Queue
      ///
      /// Parent Type: `Queue`
      struct Queue: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Queue }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(QueueDetails.self),
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

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var queueDetails: QueueDetails { _toFragment() }
        }
      }
    }
  }

}