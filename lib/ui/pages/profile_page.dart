import 'package:flutter/material.dart';
import 'package:learnable/auth.dart';
import 'package:learnable/locale/locales.dart';
import 'package:learnable/color_config.dart' as colorConfig;
import 'package:learnable/models/user.dart';

final localizations = AppLocalizations();

class ProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final assetsImage = AssetImage('assets/images/axolotl_background.png');

    void _changeEmail() {
    }

    void _changePassword() {
    }

    void _onLogout() {
      AuthStateProvider().logout();
      Navigator.of(context).pushReplacementNamed("/login");
    }

    return Scaffold(
      backgroundColor: colorConfig.PRIMARY_COLOR_DARK,
      appBar: AppBar(
        title: Text(""),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: assetsImage,
            fit: BoxFit.fitWidth,
            colorFilter: ColorFilter.mode(colorConfig.PRIMARY_COLOR_DARK.withOpacity(0.2), BlendMode.dstATop),
          )
        ),
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[

            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                User().fullName(),
                style: TextStyle(
                    color: colorConfig.BRIGHT_FONT_COLOR,
                    fontSize: 40.0
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                User().email,
                style: TextStyle(
                    color: colorConfig.BRIGHT_FONT_COLOR,
                    fontSize: 16.0
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                User().username,
                style: TextStyle(
                    color: colorConfig.BRIGHT_FONT_COLOR,
                    fontSize: 16.0
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                onTap: _changeEmail,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: colorConfig.BRIGHT_FONT_COLOR,
                    border: Border.all(
                      color: colorConfig.BRIGHT_FONT_COLOR,
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))
                  ),
                  child: Text(
                    localizations.changeEmail,
                    style: TextStyle(
                      color: colorConfig.PRIMARY_COLOR_LIGHT,
                      fontSize: 16.0
                    ),
                  ),
                )
              )
            ),

            Container(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: _changePassword,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: colorConfig.PRIMARY_COLOR_LIGHT,
                    border: Border.all(
                      color: colorConfig.PRIMARY_COLOR_LIGHT,
                      width: 2.0
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))
                  ),
                  child: Text(
                    localizations.changePassword,
                    style: TextStyle(
                      color: colorConfig.BRIGHT_FONT_COLOR,
                      fontSize: 16.0
                    ),
                  ),
                )
              )
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
              child: Divider(
                color: colorConfig.BRIGHT_FONT_COLOR,
              ),
            ),

            Container(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: _onLogout,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: colorConfig.BRIGHT_FONT_COLOR,
                            width: 2.0
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0))
                    ),
                    child: Text(
                      localizations.signOut,
                      style: TextStyle(
                          color: colorConfig.BRIGHT_FONT_COLOR,
                          fontSize: 16.0
                      ),
                    ),
                  ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
