// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class GetEventFormatsQuery: GraphQLQuery {
    static let operationName: String = "getEventFormats"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query getEventFormats { eventFormats { ...EventFormatDetails __typename } }"#,
        fragments: [EventFormatDetails.self]
      ))

    public init() {}

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("eventFormats", [EventFormat].self),
      ] }

      /// Retrieve a list of all available event formats in the selected locale's language.
      var eventFormats: [EventFormat] { __data["eventFormats"] }

      /// EventFormat
      ///
      /// Parent Type: `EventFormat`
      struct EventFormat: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.EventFormat }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(EventFormatDetails.self),
        ] }

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