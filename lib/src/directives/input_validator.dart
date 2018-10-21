import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

/// Input validator to use regex directly in the HTML
@Directive(
    selector: ''
        '[pattern][ngControl],'
        '[pattern][ngFormControl],'
        '[pattern][ngModel]',
    providers: const [
      const Provider(NG_VALIDATORS, useExisting: PatternValidator, multi: true)
    ])
class InputValidator extends PatternValidator {
  /// Constructor, insert InputValidator in the directives of the component
  InputValidator(@Attribute('pattern') String pattern) : super(pattern);
}
