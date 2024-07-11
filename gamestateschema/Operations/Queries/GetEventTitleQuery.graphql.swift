// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class GetEventTitleQuery: GraphQLQuery {
    static let operationName: String = "getEventTitle"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query getEventTitle($eventId: ID!) { event(id: $eventId) { __typename title } }"#
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
          .field("title", String.self),
        ] }

        /// The title of the event.
        var title: String { __data["title"] }
      }
    }
  }

}