import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/app_component.template.dart' as ng;

import 'package:firebase/firebase.dart' as fb;

import 'main.template.dart' as self;

@GenerateInjector(
  routerProviders,
)
final InjectorFactory injector = self.injector$Injector;

void main() {

  // ENVIRONMENT
  try {
    fb.initializeApp(
        apiKey: '',
        authDomain: '',
        databaseURL: '',
        projectId: '',
        storageBucket: '',
        messagingSenderId: '');
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }

  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
