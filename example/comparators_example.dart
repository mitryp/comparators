import 'package:collection/collection.dart' show ComparatorExtension;
import 'package:comparators/comparators.dart';

final List<User> users = [
  const User(
    id: 0,
    username: 'JohnDoe',
    email: 'jdoe@example.com',
    isActive: false,
  ),
  const User(
    id: 1,
    username: 'Kathelie',
    email: 'kate@mail.com',
    isActive: true,
  ),
  const User(
    id: 2,
    username: 'miX',
    email: 'mix@example.com',
    isActive: false,
  ),
  const User(
    id: 3,
    username: 'mr_cat',
    email: 'mr_cat@example.com',
    isActive: false,
  ),
  const User(
    id: 4,
    username: 'Evan',
    email: 'evan@example.com',
    isActive: false,
  ),
  const User(
    id: 5,
    username: 'mitryp',
    email: 'mitryp@example.net',
    isActive: true,
  ),
];

void main() {
  var usersCopy = [...users];
  void reset() => usersCopy = [...users];
  void printUsers({String trailing = '\n'}) =>
      print('${usersCopy.join('\n')}$trailing');

  printUsers();

  // this will sort the list by the username field of the User object
  usersCopy.sort(compare((u) => u.username));

  printUsers();
  reset();

  // this will sort the users by their activity first, then by their email,
  // and then by their username
  // * `inverse` is from the `package:collection`
  usersCopy.sort(compareSequentially([
    // the users which active is set to true will come first in the list
    // note that using `inverse` requires explicit type in the comparator
    compareBool((User u) => u.isActive).inverse,
    // then users will be sorted by their email field
    compare((u) => u.email),
    // and then by their username
    compare((u) => u.username),
  ]));

  printUsers();
  reset();

  // alternatively, it is possible to achieve the same result using `then` and `inverse` extension methods from the
  // `package:collection`, but it is necessary to write types explicitly in most cases
  usersCopy.sort(
    compareBool((User u) => u.isActive).inverse.then(
          compare((User u) => u.email).then(
            compare((User u) => u.username),
          ),
        ),
  );

  printUsers(trailing: '');
}

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
