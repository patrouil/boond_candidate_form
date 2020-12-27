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

import 'dart:html' as html;
import 'package:global_configuration/global_configuration.dart';
import 'package:logging/logging.dart';

class AppGlobals {
  static final Logger log = Logger("AppGlobals");

  // on user definition
  static const String _BOOND_HOST = 'boond_host';
  static const String _USER_TOKEN = 'users_token';
  static const String _CLIENT_KEY = 'client_key';
  static const String _CLIENT_TOKEN = 'client_token';
  static const String _GDPR_MESSAGE = 'gdpr.message';
  static const String _EMAIL_HR = "email.hr";
  static const String _ACCEPT_MESSAGE = "accept.message";

  AppGlobals() {
    //log.level = Level.FINE;
  }

  static String get boond_host =>
      GlobalConfiguration().getValue<String>(_BOOND_HOST);

  static String get user_token =>
      GlobalConfiguration().getValue<String>(_USER_TOKEN);

  static String get client_key =>
      GlobalConfiguration().getValue<String>(_CLIENT_KEY);

  static String get email_hr =>
      GlobalConfiguration().getValue<String>(_EMAIL_HR);

  static String get client_token =>
      GlobalConfiguration().getValue<String>(_CLIENT_TOKEN);

  static String get gdpr_message {
    return GlobalConfiguration().getValue<String>(_GDPR_MESSAGE);
  }

  static String get accept_message =>
      GlobalConfiguration().getValue<String>(_ACCEPT_MESSAGE) ??
      "well done see you soon";
}
