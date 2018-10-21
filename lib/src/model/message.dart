/// Message a user has created
class Message {
  String _content, _spaceName, _username, _userspace;
  DateTime _creationDate;

  /// Constructor
  Message(this._content, this._spaceName, this._username, this._creationDate,
      this._userspace);

  /// Gets the content of the message
  String get content => _content;

  /// Gets the Space Name the message belongs to
  String get spaceName => _spaceName;

  /// Gets the username from the user whi created the message
  String get username => _username;

  /// Gets the key user~space
  String get userspace => _userspace;

  /// Gets the creation date of the message
  DateTime get creationDate => _creationDate;

  /// Gets the creation day formated in day/month/year
  String get formatedCreationDate =>
      '${_creationDate.day}/${_creationDate.month}/${_creationDate.year}';

  @override
  String toString() => 'Message $_content. Index by $_userspace';
}
