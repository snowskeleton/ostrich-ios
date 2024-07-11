// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension Gamestateschema {
  /// The different supported sorting fields that can be passed to the EventSearchQuery
  enum EventSearchSortField: String, EnumType {
    /// The default sort where events closer to the longitude/latitude are sorted first
    case distance = "distance"
    /// Sort events returned by event starting earlier sorted first
    case date = "date"
  }

}