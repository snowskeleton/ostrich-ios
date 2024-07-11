// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct PodDetailsV2: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment PodDetailsV2 on PodV2 { __typename podNumber seats { ...SeatDetailsV2 __typename } }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.PodV2 }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("podNumber", Int.self),
      .field("seats", [Seat].self),
    ] }

    /// The pod number, a simple 1-based index. Not expected to correspond directly to
    /// any particular real-world table number.
    var podNumber: Int { __data["podNumber"] }
    /// The list of seat assignments for the pod.
    var seats: [Seat] { __data["seats"] }

    /// Seat
    ///
    /// Parent Type: `SeatV2`
    struct Seat: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.SeatV2 }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(SeatDetailsV2.self),
      ] }

      /// The seat number, a simple 1-based index. Not expected to correspond directly to
      /// any particular real-world seat number.
      var seatNumber: Int { __data["seatNumber"] }
      /// Id of the team associated with the seat
      var teamId: Gamestateschema.ID { __data["teamId"] }

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var seatDetailsV2: SeatDetailsV2 { _toFragment() }
      }
    }
  }

}