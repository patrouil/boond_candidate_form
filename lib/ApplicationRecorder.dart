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

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';

import 'package:boond_api/boond_api.dart' as boond
    show
        CandidateAttributes,
        BoondAuth,
        BoondApi,
        BoondApiError,
        CandidateSearch,
        CandidatePost,
        CandidateGet,
        ActionsPost,
        DocumentsPost,
        ActionsGet;

import 'package:flutter/material.dart'
    show AlertDialog, CircularProgressIndicator, Colors, showDialog;
import 'package:logging/logging.dart';

import 'AppGlobals.dart';
import 'ApplicationData.dart';
import 'ErrorPage.dart';
import 'ThanksPage.dart';

class ApplicationRecorder {
  static final Logger log = Logger("ApplicationRecorder");

  ApplicationData currentCandidate;

  boond.BoondApi bSession;

  ApplicationRecorder({Key key, @required this.currentCandidate}) {
    //log.level = Level.FINEST;
  }

  Future<boond.CandidateGet> _searchCandidate() async {
    boond.CandidateSearch s = await bSession.candidate.search(
        {"keywordsType": "emails", "keywords": "${currentCandidate.email}"});

    boond.CandidateGet bg;

    if (!s.data.isEmpty) {
      bg = await bSession.candidate.get(s.data.first.id);
    } else {
      bg = await this.bSession.candidate.empty();
    }
    return bg;
  }

  void _connect() {
    if (this.bSession != null) return;

    log.fine("[_connect]  ${AppGlobals.boond_host}");

    http.Client c = boond.BoondAuth.clientTokenAuth(
        clientToken: AppGlobals.client_token,
        userToken: AppGlobals.user_token,
        clientKey: AppGlobals.client_key);

    this.bSession = boond.BoondApi(c, AppGlobals.boond_host);
  }

  Future<boond.ActionsGet> _mergeAction(
      String dataType, String candidateId) async {
    boond.ActionsGet ac = await bSession.actions.empty(dataType, candidateId);

    ac.data.attributes.creationDate = DateTime.now();
    ac.data.attributes.title = "candidature formulaire Web";
    if (this.currentCandidate.message != null)
      ac.data.attributes.text = this.currentCandidate.message + '\n';
    if (this.currentCandidate.linkedIn != null)
      ac.data.attributes.text += this.currentCandidate.linkedIn + '\n';
    if (this.currentCandidate.revenuRange != null)
      ac.data.attributes.text += this.currentCandidate.revenuRange + '\n';
    if (this.currentCandidate.gdprStatus == true)
      ac.data.attributes.text += AppGlobals.gdpr_message;

    return ac;
  }

  /// civilite Mr / Mme
  /// prenom
  /// nom
  /// email
  /// phone
  /// ville
  /// linkedin
  /// salaire
  /// cv
  /// message
  void _mergeCandidate(boond.CandidateGet bg) {
    boond.CandidateAttributes bgd = bg.data.attributes;

    bgd.state = 0;

    bgd.civility = currentCandidate.civility;
    bgd.firstName = currentCandidate.firstname;
    bgd.lastName = currentCandidate.lastname;
    if (bgd.email1 == null)
      bgd.email1 = currentCandidate.email;
    else if (bgd.email2 == null)
      bgd.email2 = currentCandidate.email;
    else if (bgd.email3 == null) bgd.email3 = currentCandidate.email;

    if (bgd.phone1 == null)
      bgd.phone1 = currentCandidate.phone;
    else if (bgd.phone2 = null)
      bgd.phone2 == currentCandidate.phone;
    else if (bgd.phone3 == null) bgd.phone3 = currentCandidate.phone;

    bgd.town = currentCandidate.city;
  }

  Future<String> _saveBoond(BuildContext _context) async {
    String message;

    try {
      await this._connect();
      boond.CandidateGet bg = await this._searchCandidate();
      await _mergeCandidate(bg);
      log.fine("[_saveBoond] candaiate is ${bg.data.id}");
      if (bg.data.id == "0") {
        bg = await bSession.candidate
            .post(boond.CandidatePost.fromCandidateGet(bg));
      } else
        bg = await bSession.candidate.put_information(bg);
      // the put attachment
      boond.DocumentsPost postDoc;
      //TODO add filetype.
      postDoc = boond.DocumentsPost(
          parentId: bg.data.id,
          parentType: 'candidateResume',
          filename: currentCandidate.cv.name,
          fileContent: currentCandidate.cv.bytes);

      await bSession.documents.post(postDoc);

      // the post an action.
      await bSession.actions.empty('candidate', bg.data.id);
      boond.ActionsGet ac = await this._mergeAction(bg.data.type, bg.data.id);
      bSession.actions.post(boond.ActionsPost.fromActionsGet(ac));
    } on boond.BoondApiError catch (e) {
      log.fine("[_saveBoond.BoondApiError] status  ${e.toString()}");

      message = e.reasonPhrase;
    } catch (e) {
      message = e.toString();
    } finally {
      Future.delayed(Duration(seconds: 1), () {
        log.fine("[_saveBoond.finaly] status  $message");
        if (message != null)
          Navigator.of(_context).pushNamed(ErrorPage.route, arguments: message);
        else
          Navigator.of(_context).pushNamed(ThanksPage.route);
      });
      return message;
    }
  }

  Widget _buildDialog(BuildContext _context) {
    const double targetSize = 100.0;

    return AlertDialog(
      elevation: 5.0,
      backgroundColor: Colors.transparent,
      content: Center(
        child: Container(
          // constraints: BoxConstraints.expand(width: targetSize, height: targetSize),
          child: CircularProgressIndicator(
            backgroundColor: Colors.blueGrey,
            strokeWidth: targetSize * 0.25,
          ),
        ),
      ),
    );
  }

  Future<int> save(BuildContext _context) async {
    _saveBoond(_context);
    return showDialog<int>(
        barrierDismissible: true, context: _context, builder: _buildDialog);
  }
}
