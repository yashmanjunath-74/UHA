/// Defines the roles a user can have in the UHA system.
enum UserRole {
  patient,
  doctor,
  hospital,
  lab,
  pharmacy,
  admin,
}

/// Verification states for providers (doctors, hospitals, labs, pharmacies).
enum VerificationStatus {
  pending,
  verified,
  rejected,
}

/// Gender options.
enum Gender {
  male,
  female,
  other,
  preferNotToSay,
}
