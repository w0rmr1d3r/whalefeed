import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:whalefeed/src/model/message.dart';
import 'package:whalefeed/src/services/direction_service.dart';

/// Component for the message item
@Component(
    selector: 'message-detail',
    templateUrl: 'message_component.html',
    styleUrls: const [
      'message_component.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    directives: const [
      coreDirectives,
      MaterialIconComponent
    ])
class MessageDetailComponent {
  /// Message for the behaviour and data
  @Input()
  Message message;

  final DirectionService _direction;

  /// Constructor
  MessageDetailComponent(this._direction);

  /// Goes to the user profile
  void goToUserProfile() => _direction.goToUserProfile(message.username);

  /// Goes to the message space
  void goToMessageSpace() => _direction.goToMain(message.spaceName);
}
