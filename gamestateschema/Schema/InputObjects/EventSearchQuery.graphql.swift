// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension Gamestateschema {
  /// The search query that we send off to search for events
  struct EventSearchQuery: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      latitude: Double,
      longitude: Double,
      maxMeters: MaxMeters_Int_NotNull_min_1,
      tags: GraphQLNullable<[String]> = nil,
      sort: GraphQLNullable<GraphQLEnum<EventSearchSortField>> = nil,
      sortDirection: GraphQLNullable<GraphQLEnum<EventSearchSortDirection>> = nil,
      orgs: GraphQLNullable<[ID]> = nil,
      startDate: GraphQLNullable<DateTime> = nil,
      endDate: GraphQLNullable<DateTime> = nil,
      page: GraphQLNullable<Page_Int_min_0> = nil,
      pageSize: GraphQLNullable<PageSize_Int_min_1> = nil
    ) {
      __data = InputDict([
        "latitude": latitude,
        "longitude": longitude,
        "maxMeters": maxMeters,
        "tags": tags,
        "sort": sort,
        "sortDirection": sortDirection,
        "orgs": orgs,
        "startDate": startDate,
        "endDate": endDate,
        "page": page,
        "pageSize": pageSize
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

    /// The range that we will search for events expanding out from the point created
    /// by the longitude and latitude
    var maxMeters: MaxMeters_Int_NotNull_min_1 {
      get { __data["maxMeters"] }
      set { __data["maxMeters"] = newValue }
    }

    /// Specific tags that the events we search for should match
    var tags: GraphQLNullable<[String]> {
      get { __data["tags"] }
      set { __data["tags"] = newValue }
    }

    /// The field that we should sort the results on
    var sort: GraphQLNullable<GraphQLEnum<EventSearchSortField>> {
      get { __data["sort"] }
      set { __data["sort"] = newValue }
    }

    /// The direction of the sorted results
    var sortDirection: GraphQLNullable<GraphQLEnum<EventSearchSortDirection>> {
      get { __data["sortDirection"] }
      set { __data["sortDirection"] = newValue }
    }

    /// A list of organization ids that you want to only return events from
    var orgs: GraphQLNullable<[ID]> {
      get { __data["orgs"] }
      set { __data["orgs"] = newValue }
    }

    /// The earliest start date for events that you are searching for
    var startDate: GraphQLNullable<DateTime> {
      get { __data["startDate"] }
      set { __data["startDate"] = newValue }
    }

    /// The latest 'start date' for events that you are searching for
    var endDate: GraphQLNullable<DateTime> {
      get { __data["endDate"] }
      set { __data["endDate"] = newValue }
    }

    /// The page of event results that you want to request
    var page: GraphQLNullable<Page_Int_min_0> {
      get { __data["page"] }
      set { __data["page"] = newValue }
    }

    /// The maximum number of events you want to return per page
    var pageSize: GraphQLNullable<PageSize_Int_min_1> {
      get { __data["pageSize"] }
      set { __data["pageSize"] = newValue }
    }
  }

}