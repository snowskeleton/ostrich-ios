// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension Gamestateschema {
  struct StoreByLocationInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      latitude: Double,
      longitude: Double,
      maxMeters: Int,
      page: GraphQLNullable<Page_Int_min_0> = nil,
      pageSize: GraphQLNullable<PageSize_Int_min_1> = nil,
      isPremium: GraphQLNullable<Bool> = nil
    ) {
      __data = InputDict([
        "latitude": latitude,
        "longitude": longitude,
        "maxMeters": maxMeters,
        "page": page,
        "pageSize": pageSize,
        "isPremium": isPremium
      ])
    }

    /// The latitude for the point we will be search around
    var latitude: Double {
      get { __data["latitude"] }
      set { __data["latitude"] = newValue }
    }

    /// The longitude for the point we will be search around
    var longitude: Double {
      get { __data["longitude"] }
      set { __data["longitude"] = newValue }
    }

    /// The range that we will search for stores expanding out from the point created
    /// by the longitude and latitude
    var maxMeters: Int {
      get { __data["maxMeters"] }
      set { __data["maxMeters"] = newValue }
    }

    /// The page of store results that you want to request
    var page: GraphQLNullable<Page_Int_min_0> {
      get { __data["page"] }
      set { __data["page"] = newValue }
    }

    /// The maximum number of stores you want to return per page
    var pageSize: GraphQLNullable<PageSize_Int_min_1> {
      get { __data["pageSize"] }
      set { __data["pageSize"] = newValue }
    }

    /// Should the response include only premium stores
    var isPremium: GraphQLNullable<Bool> {
      get { __data["isPremium"] }
      set { __data["isPremium"] = newValue }
    }
  }

}