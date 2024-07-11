// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  class StoreByLocationQuery: GraphQLQuery {
    static let operationName: String = "storeByLocation"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query storeByLocation($location: StoreByLocationInput!) { storesByLocation(input: $location) { __typename pageInfo { __typename pageSize page totalResults } hasMoreResults stores { ...OrganizationDetails __typename } } }"#,
        fragments: [OrganizationDetails.self]
      ))

    public var location: StoreByLocationInput

    public init(location: StoreByLocationInput) {
      self.location = location
    }

    public var __variables: Variables? { ["location": location] }

    struct Data: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("storesByLocation", StoresByLocation.self, arguments: ["input": .variable("location")]),
      ] }

      /// Get multiple store information at once by a list of store ids
      var storesByLocation: StoresByLocation { __data["storesByLocation"] }

      /// StoresByLocation
      ///
      /// Parent Type: `StorePage`
      struct StoresByLocation: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.StorePage }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("pageInfo", PageInfo.self),
          .field("hasMoreResults", Bool?.self),
          .field("stores", [Store].self),
        ] }

        var pageInfo: PageInfo { __data["pageInfo"] }
        var hasMoreResults: Bool? { __data["hasMoreResults"] }
        var stores: [Store] { __data["stores"] }

        /// StoresByLocation.PageInfo
        ///
        /// Parent Type: `PageInfo`
        struct PageInfo: Gamestateschema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.PageInfo }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("pageSize", Int.self),
            .field("page", Int.self),
            .field("totalResults", Int.self),
          ] }

          /// The number of results per page that was used for the search.
          var pageSize: Int { __data["pageSize"] }
          /// Which page of results the returned list represents, in the context of `pageSize`.
          var page: Int { __data["page"] }
          /// The total number of results that were found for the search.
          var totalResults: Int { __data["totalResults"] }
        }

        /// StoresByLocation.Store
        ///
        /// Parent Type: `Organization`
        struct Store: Gamestateschema.SelectionSet {
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
      }
    }
  }

}