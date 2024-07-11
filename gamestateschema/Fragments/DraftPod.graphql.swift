// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct DraftPod: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment DraftPod on DraftV2 { __typename pods { ...PodDetailsV2 __typename } timerId }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.DraftV2 }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("pods", [Pod].self),
      .field("timerId", Gamestateschema.ID?.self),
    ] }

    /// The list of draft pod assignments for the event. Only applicable for a draft formats
    /// (e.g., `WOTC_DRAFT`).
    var pods: [Pod] { __data["pods"] }
    /// GUID or UUID of that represents Timer ID of Timer GraphQL for Drafting
    var timerId: Gamestateschema.ID? { __data["timerId"] }

    /// Pod
    ///
    /// Parent Type: `PodV2`
    struct Pod: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.PodV2 }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(PodDetailsV2.self),
      ] }

      /// The pod number, a simple 1-based index. Not expected to correspond directly to
      /// any particular real-world table number.
      var podNumber: Int { __data["podNumber"] }
      /// The list of seat assignments for the pod.
      var seats: [Seat] { __data["seats"] }

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var podDetailsV2: PodDetailsV2 { _toFragment() }
      }

      /// Pod.Seat
      ///
      /// Parent Type: `SeatV2`
      struct Seat: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.SeatV2 }

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

}