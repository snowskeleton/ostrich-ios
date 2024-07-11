// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class MyActiveEventsQuery: GraphQLQuery {
    static let operationName: String = "myActiveEvents"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query myActiveEvents { myActiveEvents { ...EventDetailsMyActive __typename } }"#,
        fragments: [EventDetailsMyActive.self, EventFormatDetails.self]
      ))

    public init() {}

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("myActiveEvents", [MyActiveEvent].self),
      ] }

      /// Get active events of current user.
      var myActiveEvents: [MyActiveEvent] { __data["myActiveEvents"] }

      /// MyActiveEvent
      ///
      /// Parent Type: `Event`
      struct MyActiveEvent: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Event }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(EventDetailsMyActive.self),
        ] }

        var id: Gamestateschema.ID { __data["id"] }
        /// A short (generally 6-character) string that uniquely identifies this event. Used
        /// by the player experience for easy event signup.
        var shortCode: String? { __data["shortCode"] }
        /// The persona id of the user that created this event.
        var createdBy: Gamestateschema.ID? { __data["createdBy"] }
        /// The title of the event.
        var title: String { __data["title"] }
        /// The format of the event.
        var eventFormat: EventFormat? { __data["eventFormat"] }
        /// The time that the event is scheduled to begin, for use in calendaring tools. This
        /// is not necessarily the time that the event will actually begin.
        var scheduledStartTime: Gamestateschema.DateTime? { __data["scheduledStartTime"] }
        /// The time at which an authorized user started the event. Not necessarily the same
        /// time that its first round began. `null` unless the event has been started.
        var actualStartTime: Gamestateschema.DateTime? { __data["actualStartTime"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var eventDetailsMyActive: EventDetailsMyActive { _toFragment() }
        }

        /// MyActiveEvent.EventFormat
        ///
        /// Parent Type: `EventFormat`
        struct EventFormat: Gamestateschema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.EventFormat }

          /// The type-specific, unique-identifier of this event format
          var id: Gamestateschema.ID { __data["id"] }
          /// The name of the format
          var name: String { __data["name"] }
          /// Whether events in this format include a Drafting phase
          var includesDraft: Bool { __data["includesDraft"] }
          /// Whether events in this format include a Deck Construction phase
          var includesDeckbuilding: Bool { __data["includesDeckbuilding"] }

          struct Fragments: FragmentContainer {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            var eventFormatDetails: EventFormatDetails { _toFragment() }
          }
        }
      }
    }
  }

}