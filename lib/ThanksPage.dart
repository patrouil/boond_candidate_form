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

import 'package:boond_candidate_form/AppGlobals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Scaffold;

class ThanksPage extends StatelessWidget {
  static String route = "/thanks";

  final String title;

  const ThanksPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg = AppGlobals.accept_message;

    if (msg == null || msg.isEmpty) msg = "OK";
    return Scaffold(
      appBar: null,
      drawer: null,
      body: Center(
          child: Text(
        msg,
        textAlign: TextAlign.center,
      )),
    );
  }
}
