// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct SeatDetails: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment SeatDetails on Seat { __typename number personaId displayName firstName lastName team { ...TeamDetails __typename } }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Seat }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("number", Int.self),
      .field("personaId", Gamestateschema.ID?.self),
      .field("displayName", String?.self),
      .field("firstName", String?.self),
      .field("lastName", String?.self),
      .field("team", Team?.self),
    ] }

    /// The seat number, a simple 1-based index. Not expected to correspond directly to
    /// any particular real-world seat number.
    var number: Int { __data["number"] }
    /// The persona ID of the player assigned to this seat, if any.
    var personaId: Gamestateschema.ID? { __data["personaId"] }
    /// The display name of the player assigned to this seat, if any.
    var displayName: String? { __data["displayName"] }
    /// The first name of the player assigned to this seat, if any.
    var firstName: String? { __data["firstName"] }
    /// The last name of the player assigned to this seat, if any.
    var lastName: String? { __data["lastName"] }
    /// Id of the team associated with the player
    var team: Team? { __data["team"] }

    /// Team
    ///
    /// Parent Type: `Team`
    struct Team: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Team }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(TeamDetails.self),
      ] }

      /// The ID of the team.
      var id: Gamestateschema.ID { __data["id"] }
      /// The name of the team.
      var name: String? { __data["name"] }
      /// The players who make up the team.
      var players: [Player] { __data["players"] }
      /// Game level results
      var results: [Result]? { __data["results"] }

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var teamDetails: TeamDetails { _toFragment() }
      }

      /// Team.Player
      ///
      /// Parent Type: `User`
      struct Player: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.User }

        /// The personaId of the user.
        var personaId: Gamestateschema.ID { __data["personaId"] }
        /// The user's display name as returned from Platform.
        var displayName: String? { __data["displayName"] }
        /// The user's first name.
        var firstName: String? { __data["firstName"] }
        /// The user's last name.
        var lastName: String? { __data["lastName"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var userDetails: UserDetails { _toFragment() }
        }
      }

      /// Team.Result
      ///
      /// Parent Type: `TeamResult`
      struct Result: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamResult }

        /// holds game-level draws
        var draws: Int { __data["draws"] }
        /// Is this result currently a playoff result
        var isPlayoffResult: Bool? { __data["isPlayoffResult"] }
        /// The Persona id of the submitter for this result
        var submitter: Gamestateschema.ID { __data["submitter"] }
        /// Is this a final result
        var isFinal: Bool? { __data["isFinal"] }
        /// Is the submitter a TO
        var isTO: Bool? { __data["isTO"] }
        /// Is this result a bye
        var isBye: Bool? { __data["isBye"] }
        /// The current results wins
        var wins: Int? { __data["wins"] }
        /// The current results losses
        var losses: Int? { __data["losses"] }
        /// The id for which team this result applies to
        var teamId: Gamestateschema.ID { __data["teamId"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var resultDetails: ResultDetails { _toFragment() }
        }
      }
    }
  }

}