// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension Gamestateschema {
  /// Whether this registration matches a Wizards account, a guest Wizards account, or has no match.
  enum PlatformStatus: String, EnumType {
    /// This registration matches a real Wizard account.
    case found = "FOUND"
    /// This registration does not match a real Wizards account, and will have no persona ID.
    case notfound = "NOTFOUND"
    /// This registration is for a temporary guest account that has a persona ID.
    case guest = "GUEST"
  }

}