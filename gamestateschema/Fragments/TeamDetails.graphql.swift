// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct TeamDetails: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment TeamDetails on Team { __typename id name players { ...UserDetails __typename } results { ...ResultDetails __typename } }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.Team }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", Gamestateschema.ID.self),
      .field("name", String?.self),
      .field("players", [Player].self),
      .field("results", [Result]?.self),
    ] }

    /// The ID of the team.
    var id: Gamestateschema.ID { __data["id"] }
    /// The name of the team.
    var name: String? { __data["name"] }
    /// The players who make up the team.
    var players: [Player] { __data["players"] }
    /// Game level results
    var results: [Result]? { __data["results"] }

    /// Player
    ///
    /// Parent Type: `User`
    struct Player: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.User }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(UserDetails.self),
      ] }

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

    /// Result
    ///
    /// Parent Type: `TeamResult`
    struct Result: Gamestateschema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamResult }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(ResultDetails.self),
      ] }

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