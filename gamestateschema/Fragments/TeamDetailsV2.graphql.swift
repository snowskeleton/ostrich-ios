// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct TeamDetailsV2: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment TeamDetailsV2 on TeamV2 { __typename teamId teamName players { ...UserDetails __typename } }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.TeamV2 }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("teamId", Gamestateschema.ID.self),
      .field("teamName", String?.self),
      .field("players", [Player].self),
    ] }

    /// The ID of the team.
    var teamId: Gamestateschema.ID { __data["teamId"] }
    /// The name of the team.
    var teamName: String? { __data["teamName"] }
    /// The players who make up the team.
    var players: [Player] { __data["players"] }

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
  }

}