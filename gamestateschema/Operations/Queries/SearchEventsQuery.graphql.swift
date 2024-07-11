// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class SearchEventsQuery: GraphQLQuery {
    static let operationName: String = "searchEvents"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query searchEvents($searchEvents: EventSearchQuery!) { searchEvents(query: $searchEvents) { __typename pageInfo { __typename page pageSize totalResults } hasMoreResults events { __typename id organization { ...OrganizationDetails __typename } title entryFee { __typename amount currency } scheduledStartTime actualStartTime estimatedEndTime actualEndTime status capacity numberOfPlayers tags description latitude longitude address } } }"#,
        fragments: [OrganizationDetails.self]
      ))

    public var searchEvents: EventSearchQuery

    public init(searchEvents: EventSearchQuery) {
      self.searchEvents = searchEvents
    }

    public var __variables: Variables? { ["searchEvents": searchEvents] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("searchEvents", SearchEvents.self, arguments: ["query": .variable("searchEvents")]),
      ] }

      /// Provided that the search query has results this will return a list of events
      /// that match the provided search query and are in the maxMeters range from the
      /// latitude and longitude
      var searchEvents: SearchEvents { __data["searchEvents"] }

      /// SearchEvents
      ///
      /// Parent Type: `EventPage`
      struct SearchEvents: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.EventPage }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("pageInfo", PageInfo.self),
          .field("hasMoreResults", Bool?.self),
          .field("events", [Event].self),
        ] }

        var pageInfo: PageInfo { __data["pageInfo"] }
        var hasMoreResults: Bool? { __data["hasMoreResults"] }
        var events: [Event] { __data["events"] }

        /// SearchEvents.PageInfo
        ///
        /// Parent Type: `PageInfo`
        struct PageInfo: Gamestateschema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.PageInfo }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("page", Int.self),
            .field("pageSize", Int.self),
            .field("totalResults", Int.self),
          ] }

          /// Which page of results the returned list represents, in the context of `pageSize`.
          var page: Int { __data["page"] }
          /// The number of results per page that was used for the search.
          var pageSize: Int { __data["pageSize"] }
          /// The total number of results that were found for the search.
          var totalResults: Int { __data["totalResults"] }
        }

        /// SearchEvents.Event
        ///
        /// Parent Type: `Event`
        struct Event: Gamestateschema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Event }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Gamestateschema.ID.self),
            .field("organization", Organization.self),
            .field("title", String.self),
            .field("entryFee", EntryFee.self),
            .field("scheduledStartTime", Gamestateschema.DateTime?.self),
            .field("actualStartTime", Gamestateschema.DateTime?.self),
            .field("estimatedEndTime", Gamestateschema.DateTime?.self),
            .field("actualEndTime", Gamestateschema.DateTime?.self),
            .field("status", GraphQLEnum<Gamestateschema.EventStatus>.self),
            .field("capacity", Int?.self),
            .field("numberOfPlayers", Int?.self),
            .field("tags", [String].self),
            .field("description", String?.self),
            .field("latitude", Double?.self),
            .field("longitude", Double?.self),
            .field("address", String?.self),
          ] }

          var id: Gamestateschema.ID { __data["id"] }
          /// The organization that is running the event.
          var organization: Organization { __data["organization"] }
          /// The title of the event.
          var title: String { __data["title"] }
          /// The entry fee for this event, if any. Defaults to zero US dollars.
          var entryFee: EntryFee { __data["entryFee"] }
          /// The time that the event is scheduled to begin, for use in calendaring tools. This
          /// is not necessarily the time that the event will actually begin.
          var scheduledStartTime: Gamestateschema.DateTime? { __data["scheduledStartTime"] }
          /// The time at which an authorized user started the event. Not necessarily the same
          /// time that its first round began. `null` unless the event has been started.
          var actualStartTime: Gamestateschema.DateTime? { __data["actualStartTime"] }
          /// An estimate of when the event will conclude.
          var estimatedEndTime: Gamestateschema.DateTime? { __data["estimatedEndTime"] }
          /// The time at which an authorized user ended the event. Not necessarily the same
          /// time that its last round ended. `null` unless the event has been ended.
          var actualEndTime: Gamestateschema.DateTime? { __data["actualEndTime"] }
          /// Events are in the SCHEDULED status upon creation and until they are explicitly
          /// started by an authorized user. When they are started, they will transition to
          /// DRAFTING. When the first round is started, the event will move to ROUNDACTIVE
          /// and then ROUNDCERTIFIED once all scores for the round are recorded. It moves
          /// back and forth between ROUNDACTIVE and ROUNDCERTIFIED until the last round
          /// has been certified. When an authorized user ends the event, it will move to
          /// ENDED. An event will be CANCELLED only if it is deleted without ever having
          /// been started.
          var status: GraphQLEnum<Gamestateschema.EventStatus> { __data["status"] }
          /// The maximum number of players this event supports.
          var capacity: Int? { __data["capacity"] }
          /// The number of players currently registered for this event. This is a simple count
          /// of registrations; does not subtract drops.
          var numberOfPlayers: Int? { __data["numberOfPlayers"] }
          /// The tags used by Store and Event Locator for this event.
          var tags: [String] { __data["tags"] }
          /// The description of the event.
          var description: String? { __data["description"] }
          /// The latitude of the event's location.
          var latitude: Double? { __data["latitude"] }
          /// The longitude of the event's location.
          var longitude: Double? { __data["longitude"] }
          /// The street address of the event's location. Does not include HTML; uses line breaks for
          /// formatting.
          var address: String? { __data["address"] }

          /// SearchEvents.Event.Organization
          ///
          /// Parent Type: `Organization`
          struct Organization: Gamestateschema.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Organization }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(OrganizationDetails.self),
            ] }

            var id: Gamestateschema.ID { __data["id"] }
            /// The name of the organization.
            var name: String { __data["name"] }
            /// The latitude of the organization's primary location.
            var latitude: Double? { __data["latitude"] }
            /// The longitude of the organization's primary location.
            var longitude: Double? { __data["longitude"] }
            /// The organization's primary phone number.
            var phoneNumber: String? { __data["phoneNumber"] }
            /// `true` if the organization has Premium status.
            var isPremium: Bool? { __data["isPremium"] }
            /// The primary postal address of the organization.
            var postalAddress: String { __data["postalAddress"] }
            /// The organization's primary web site URL.
            var website: String? { __data["website"] }

            struct Fragments: FragmentContainer {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              var organizationDetails: OrganizationDetails { _toFragment() }
            }
          }

          /// SearchEvents.Event.EntryFee
          ///
          /// Parent Type: `Money`
          struct EntryFee: Gamestateschema.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Money }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("amount", Int.self),
              .field("currency", Gamestateschema.CurrencyCode.self),
            ] }

            /// Amounts are specified in minor currency units (e.g.: cents).
            var amount: Int { __data["amount"] }
            /// The ISO 4217 currency code, expressed as a string.
            var currency: Gamestateschema.CurrencyCode { __data["currency"] }
          }
        }
      }
    }
  }

}