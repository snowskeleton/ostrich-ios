// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension Gamestateschema {
  struct TeamPlayerInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      registrationId: GraphQLNullable<ID> = nil,
      reservationId: GraphQLNullable<ID> = nil,
      personaId: PersonaId_String_NotNull_maxLength_50,
      email: GraphQLNullable<Email_String_format_email> = nil
    ) {
      __data = InputDict([
        "registrationId": registrationId,
        "reservationId": reservationId,
        "personaId": personaId,
        "email": email
      ])
    }

    /// The ID of the registration.
    var registrationId: GraphQLNullable<ID> {
      get { __data["registrationId"] }
      set { __data["registrationId"] = newValue }
    }

    /// The ID of the reservation.
    var reservationId: GraphQLNullable<ID> {
      get { __data["reservationId"] }
      set { __data["reservationId"] = newValue }
    }

    /// The persona ID of the new player.
    var personaId: PersonaId_String_NotNull_maxLength_50 {
      get { __data["personaId"] }
      set { __data["personaId"] = newValue }
    }

    /// The email for the player.
    var email: GraphQLNullable<Email_String_format_email> {
      get { __data["email"] }
      set { __data["email"] = newValue }
    }
  }

}