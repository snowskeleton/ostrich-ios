// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct SeatDetailsV2: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment SeatDetailsV2 on SeatV2 { __typename seatNumber teamId }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.SeatV2 }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("seatNumber", Int.self),
      .field("teamId", Gamestateschema.ID.self),
    ] }

    /// The seat number, a simple 1-based index. Not expected to correspond directly to
    /// any particular real-world seat number.
    var seatNumber: Int { __data["seatNumber"] }
    /// Id of the team associated with the seat
    var teamId: Gamestateschema.ID { __data["teamId"] }
  }

}