/*
 * Copyright (c) patrouil 2020.
 *  This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 *  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import 'dart:core';

import 'package:logging/logging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show MaterialApp, ThemeData, VisualDensity;

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'ErrorPage.dart';
import 'ThanksPage.dart';
import 'WelcomePage.dart';

class BoondCandidateForm extends StatefulWidget {
  static final log = Logger('BoondCandidateForm');

  static String APP_TITLE = 'Boond Candidate Workflow';

  BoondCandidateForm() : super() {
    //log.level = Level.FINEST;
  }

  static void setLocale(BuildContext context, Locale newLocale) {
    _BoondCandidateFormState state =
        context.findAncestorStateOfType<_BoondCandidateFormState>();
    state.setLocale(newLocale);
  }

  @override
  State<StatefulWidget> createState() => _BoondCandidateFormState();
}

class _BoondCandidateFormState extends State<BoondCandidateForm> {
  static final log = BoondCandidateForm.log;

  Locale _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    Uri u = Uri.base;

    log.fine("[build]  ${u.host} ");
    return MaterialApp(
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate
      ],
      routes: {
        WelcomePage.route: (coontext) => WelcomePage(),
        ErrorPage.route: (context) => ErrorPage(),
        ThanksPage.route: (context) => ThanksPage(),
      },
      initialRoute: WelcomePage.route,
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
