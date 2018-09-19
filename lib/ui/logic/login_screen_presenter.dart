import 'package:learnable/data/rest_api.dart';
import 'package:learnable/locale/locales.dart';

abstract class LoginScreenContract {
  void onLoginSuccess();
  void onLoginError(String error);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestAPI api = new RestAPI();
  LoginScreenPresenter(this._view);

  doLogin(String q, String password, int rememberMe) {
    api.login(q, password, rememberMe)
        .then((n) => api.getLoggedInUser().then((user) => _view.onLoginSuccess()))
        .catchError((error) => _view.onLoginError(AppLocalizations().pleaseCheckYourCredentials));
  }
}