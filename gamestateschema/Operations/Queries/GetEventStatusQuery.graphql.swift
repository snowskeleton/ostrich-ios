// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class GetEventStatusQuery: GraphQLQuery {
    static let operationName: String = "getEventStatus"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query getEventStatus($eventId: ID!) { event(id: $eventId) { __typename status } }"#
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
        .field("event", Event?.self, arguments: ["id": .variable("eventId")]),
      ] }

      /// Get an event by ID.
      var event: Event? { __data["event"] }

      /// Event
      ///
      /// Parent Type: `Event`
      struct Event: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Event }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("status", GraphQLEnum<Gamestateschema.EventStatus>.self),
        ] }

        /// Events are in the SCHEDULED status upon creation and until they are explicitly
        /// started by an authorized user. When they are started, they will transition to
        /// DRAFTING. When the first round is started, the event will move to ROUNDACTIVE
        /// and then ROUNDCERTIFIED once all scores for the round are recorded. It moves
        /// back and forth between ROUNDACTIVE and ROUNDCERTIFIED until the last round
        /// has been certified. When an authorized user ends the event, it will move to
        /// ENDED. An event will be CANCELLED only if it is deleted without ever having
        /// been started.
        var status: GraphQLEnum<Gamestateschema.EventStatus> { __data["status"] }
      }
    }
  }

}