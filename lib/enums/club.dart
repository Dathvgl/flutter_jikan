enum CategoryClubType {
  anime,
  character,
  people,
}

enum AccessClubType {
  public,
  private;

  String get subtitle {
    switch (this) {
      case AccessClubType.public:
        return "Anyone can join";
      case AccessClubType.private:
        return "Request to join";
    }
  }
}

enum RoleClubType {
  host,
  admin,
  member,
  none,
}
