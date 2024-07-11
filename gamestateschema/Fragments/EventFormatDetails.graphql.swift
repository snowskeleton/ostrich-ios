// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Gamestateschema {
  struct EventFormatDetails: Gamestateschema.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment EventFormatDetails on EventFormat { __typename id name includesDraft includesDeckbuilding }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { Gamestateschema.Objects.EventFormat }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", Gamestateschema.ID.self),
      .field("name", String.self),
      .field("includesDraft", Bool.self),
      .field("includesDeckbuilding", Bool.self),
    ] }

    /// The type-specific, unique-identifier of this event format
    var id: Gamestateschema.ID { __data["id"] }
    /// The name of the format
    var name: String { __data["name"] }
    /// Whether events in this format include a Drafting phase
    var includesDraft: Bool { __data["includesDraft"] }
    /// Whether events in this format include a Deck Construction phase
    var includesDeckbuilding: Bool { __data["includesDeckbuilding"] }
  }

}