// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct DeckConstructionDetails: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment DeckConstructionDetails on DeckConstructionV2 { __typename timerId seats { ...SeatDetailsV2 __typename } }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.DeckConstructionV2 }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("timerId", Gamestateschema.ID?.self),
      .field("seats", [Seat].self),
    ] }

    /// GUID or UUID of that represents Timer ID of Timer GraphQL for Deck Construction
    var timerId: Gamestateschema.ID? { __data["timerId"] }
    /// The list of seat assignments for the phase.
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