import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/routes.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/converter_service.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/db_service.dart';
import 'package:whalefeed/src/services/direction_service.dart';
import 'package:whalefeed/src/services/follow_service.dart';
import 'package:whalefeed/src/services/input_cleaner_service.dart';
import 'package:whalefeed/src/services/json_parser_service.dart';
import 'package:whalefeed/src/services/map_to_object_service.dart';
import 'package:whalefeed/src/services/object_to_map_service.dart';
import 'package:whalefeed/src/services/orderer_service.dart';

/// AppComponent, configs routes, injects common services
@Component(selector: 'my-app', template: '''
    <router-outlet [routes]="Routes.all"></router-outlet>
  ''', directives: const [
  routerDirectives
], providers: const [
  materialProviders,
  ClassProvider(AuthService),
  ClassProvider(ConverterService),
  ClassProvider(CurrentUserService),
  ClassProvider(DBService),
  ClassProvider(DirectionService),
  ClassProvider(FollowService),
  ClassProvider(InputCleanerService),
  ClassProvider(JSONParserService),
  ClassProvider(MapToObjectService),
  ClassProvider(ObjectToMapService),
  ClassProvider(OrdererService),
], exports: [
  RoutePaths,
  Routes
])
class AppComponent {}
