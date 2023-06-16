import 'package:comparators/comparators.dart';
import 'package:comparators/extensions.dart';

final List<User> users = [
  const User(id: 0, username: 'JohnDoe', email: 'jdoe@example.com', isActive: false),
  const User(id: 1, username: 'Kathelie', email: 'kate@mail.com', isActive: true),
  const User(id: 2, username: 'miX', email: 'mix@example.com', isActive: false),
  const User(id: 3, username: 'mr_cat', email: 'mr_cat@example.com', isActive: false),
  const User(id: 4, username: 'Evan', email: 'evan@example.com', isActive: false),
  const User(id: 5, username: 'mitryp', email: 'mitryp@example.net', isActive: true),
];

void main() {
  _printUsers();

  // this will sort the list by the username field of the User object
  users.sort(compare((u) => u.username));

  _printUsers();

  // this will sort the users by their username
  // before comparing the usernames will be transformed with the provided transform
  // in this case, it will lowercase the names to do a case insensitive comparison
  users.sort(
    compareTransformed<User, String>((u) => u.username, (name) => name.toLowerCase()),
  );

  _printUsers();

  // this will sort the users by their activity first, then by their email,
  // and then by their username
  users.sort(
    // the users which active is set to true will come first in the list
    compareBool<User>((u) => u.isActive).reversed.then(
          // then users will be sorted by their email field
          compare<User>((u) => u.email).then(
            // and then by their username
            compare<User>((u) => u.username),
          ),
        ),
  );

  _printUsers(trailing: '');
}

void _printUsers({String trailing = '\n'}) => print('${users.join('\n')}$trailing');

/// A class representing a user with an id, username, email and activity status.
class User {
  final int id;
  final String username;
  final String email;
  final bool isActive;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.isActive,
  });

  @override
  String toString() => 'User($id, $username, $email, active: $isActive)';
}
