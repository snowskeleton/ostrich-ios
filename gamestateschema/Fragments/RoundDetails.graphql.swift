// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct RoundDetails: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment RoundDetails on Round { __typename id number isFinalRound isCertified matches { ...MatchDetails __typename } canRollback timerID }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Round }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", Gamestateschema.ID.self),
      .field("number", Int.self),
      .field("isFinalRound", Bool?.self),
      .field("isCertified", Bool?.self),
      .field("matches", [Match].self),
      .field("canRollback", Bool?.self),
      .field("timerID", Gamestateschema.ID?.self),
    ] }

    /// A fabricated ID, used so that Apollo Client can easily cache Round objects.
    var id: Gamestateschema.ID { __data["id"] }
    /// The round number. The first round is numbered 1.
    var number: Int { __data["number"] }
    /// Is this the final round?
    var isFinalRound: Bool? { __data["isFinalRound"] }
    /// Have this round's scores been certified?
    var isCertified: Bool? { __data["isCertified"] }
    /// The matches (pairings) for this round.
    var matches: [Match] { __data["matches"] }
    /// Is this a round that the rollback option is available
    var canRollback: Bool? { __data["canRollback"] }
    /// GUID or UUID of that represents Timer ID of Timer GraphQL
    var timerID: Gamestateschema.ID? { __data["timerID"] }

    /// Match
    ///
    /// Parent Type: `Match`
    struct Match: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Match }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(MatchDetails.self),
      ] }

      /// The ID of the match.
      var id: Gamestateschema.ID { __data["id"] }
      /// Is this match a bye?
      var isBye: Bool? { __data["isBye"] }
      /// The teams participating in this match. By convention the first time in this array is
      /// the 'left' team, and the second is the 'right' team. This will need to change when
      /// we support multi-team games such as Commander.
      var teams: [Team] { __data["teams"] }
      /// The number of game wins the left (first) team has achieved in this match. Will be 0 if the
      /// left team is being dropped. `null` if no game results have yet been recorded for this match.
      var leftTeamWins: Int? { __data["leftTeamWins"] }
      /// The number of game wins the right (second) team has achieved in this match. Will be 0 if this
      /// is a bye, or if the right team is being dropped. `null` if no game results have yet been
      /// recorded for this match.
      var rightTeamWins: Int? { __data["rightTeamWins"] }
      /// The table number at which the match will be played.
      var tableNumber: Int? { __data["tableNumber"] }

      struct Fragments: FragmentContainer {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        var matchDetails: MatchDetails { _toFragment() }
      }

      /// Match.Team
      ///
      /// Parent Type: `Team`
      struct Team: Gamestateschema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Team }

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

        /// Match.Team.Player
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

        /// Match.Team.Result
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

}