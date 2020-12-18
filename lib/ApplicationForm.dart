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
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show
        ButtonBar,
        CheckboxListTile,
        DropdownButtonFormField,
        DropdownMenuItem,
        ElevatedButton,
        InputDecoration,
        MaterialLocalizations,
        OutlineInputBorder,
        RaisedButton,
        TextFormField,
        ToggleButtons;

import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'ApplicationData.dart';
import 'ApplicationRecorder.dart';
import 'BoondCandidateForm.dart';
import 'widget/BoondDropdownFormField.dart';

class ApplicationForm extends StatefulWidget {
  static final Logger log = Logger("ApplicationForm");

  ApplicationForm() : super() {
    //log.level = Level.FINEST;
  }
  @override
  State<StatefulWidget> createState() => _ApplicationFormState();
}

enum FormLang { English, French }

class _ApplicationFormState extends State<ApplicationForm> {
  static final Logger log = ApplicationForm.log;

  FormLang _formLang = FormLang.English;

  final _formKey = GlobalKey<FormState>();

  ApplicationData userData = ApplicationData();

  @override
  void initState() {
    super.initState();

    userData.firstname = AppGlobals.hostname;
  }

  Widget _buildLang(BuildContext _context) {
    const List<Text> langList = [const Text('EN'), const Text('FR')];

    return ButtonBar(alignment: MainAxisAlignment.end, children: [
      ToggleButtons(
        children: langList,
        onPressed: (int index) {
          setState(() {
            this._formLang = FormLang.values[index];
          });
          String lang = langList[index].data.toLowerCase();
          log.fine("[_buildLang] press $lang");

          Locale l = Locale.fromSubtags(languageCode: lang);
          BoondCandidateForm.setLocale(_context, l);
        },
        isSelected: [
          (this._formLang == FormLang.French),
          (this._formLang == FormLang.English)
        ],
      ),
    ]);
  }

  Widget _buildCivilite(BuildContext c) {
    List<String> _civiliteList = [
      AppLocalizations.of(c).mister,
      AppLocalizations.of(c).madam
    ];

    Widget w = BoondDropdownFormField<String>(
      entries: _civiliteList,
      selectedId: userData.civility ?? 0,
      onChanged: (String v) {
        userData.civility = _civiliteList.indexOf(v);
      },
      idOf: (String e) => _civiliteList.indexOf(e),
      labelOf: (dynamic e) => e,
    );
    return w;
  }

  Widget _buildFirstName(BuildContext c) {
    String v = userData.firstname;
    Widget w = TextFormField(
      controller: TextEditingController(text: v),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(labelText: AppLocalizations.of(c).firstname),
      onChanged: (String v) {
        userData.firstname = v.trim();
      },
      validator: (String value) {
        if (value == null || value.isEmpty)
          return AppLocalizations.of(c).mandatoryFirstName;
        return null;
      },
    );
    return w;
  }

  Widget _buildLastName(BuildContext c) {
    String v = userData.lastname;
    log.fine("[_buildLastName] build $v");

    Widget w = TextFormField(
      controller: TextEditingController(text: v),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(labelText: AppLocalizations.of(c).lastname),
      onChanged: (String v) {
        log.fine("[_buildLastName] onChanged $v");
        userData.lastname = v.trim().toUpperCase();
      },
      validator: (String value) {
        if (value == null || value.isEmpty)
          return AppLocalizations.of(c).mandatoryLastName;
        return null;
      },
    );
    return w;
  }

  Widget _buildEmail(BuildContext c) {
    log.fine("[_buildEmail] builder");

    String v = userData.email;
    log.fine("[_buildEmail] calling formfield $v");

    Widget w = TextFormField(
      controller: TextEditingController(text: v),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(labelText: AppLocalizations.of(c).email),
      maxLines: 1,
      validator: (String value) {
        if (value == null || value.isEmpty)
          return AppLocalizations.of(c).mandatoryEmail;
        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return AppLocalizations.of(c).invalidEmail;
        }
        return null;
      },
      onChanged: (String v) {
        log.fine("[_buildEmail] email $v");

        userData.email = v.trim();
      },
    );
    return w;
  }

  Widget _buildPhone(BuildContext c) {
    String v = userData.phone;
    log.fine("[_buildPhone] builder $v");

    Widget w = TextFormField(
      controller: TextEditingController(text: v),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.phone,
      decoration:
          InputDecoration(labelText: AppLocalizations.of(c).phoneNumber),
      onChanged: (String v) {
        log.fine("[_buildEmail] phone $v");

        userData.phone = v.trim();
      },
      validator: (String value) {
        if (value == null || value.isEmpty)
          return AppLocalizations.of(c).mandatoryPhone;
        return null;
      },
    );
    return w;
  }

  Widget _buildCity(BuildContext c) {
    String v = userData.city;
    log.fine("[_buildCity] build $v");

    Widget w = TextFormField(
      controller: TextEditingController(text: v),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(labelText: AppLocalizations.of(c).city),
      onChanged: (String v) {
        log.fine("[_buildLastName] onChanged $v");
        userData.city = v.trim().toUpperCase();
      },
    );
    return w;
  }

  Widget _buildLinkedIn(BuildContext c) {
    String v = userData.linkedIn;
    log.fine("[_buildLinkedIn] build $v");

    Widget w = TextFormField(
      controller: TextEditingController(text: v),
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(labelText: 'LinkedIn'),
      onChanged: (String v) {
        log.fine("[_buildLinkedIn] onChanged $v");
        userData.linkedIn = v.trim().toUpperCase();
      },
    );
    return w;
  }

  Widget _buildSalary(BuildContext c) {
    const List<String> salaryEntries = [
      '30-35K€',
      '35-40K€',
      '40-45K€',
      '45-50K€',
      '50-55K€',
      '55-60K€',
      '>60K€'
    ];
    List<DropdownMenuItem<String>> l = List.empty(growable: true);

    for (String element in salaryEntries) {
      l.add(DropdownMenuItem<String>(
          value: element,
          child: Text(element + "/" + AppLocalizations.of(c).year)));
    }

    return DropdownButtonFormField<String>(
      items: l,
      value: null,
      isDense: true,
      hint: const Text('Salary'),
      onChanged: (String v) {
        log.fine("[_buildSalary] onChanged $v");
        userData.revenuRange = v.trim().toUpperCase();
      },
    );
  }

  Widget _buildCv(BuildContext c) {
    TextEditingController fieldControler =
        TextEditingController(text: userData.cv?.name);
    TextFormField fname = TextFormField(
      readOnly: true,
      controller: fieldControler,
      validator: (String value) {
        if (value == null || value.isEmpty)
          return AppLocalizations.of(c).mandatoryCV;
        return null;
      },
    );

    RaisedButton btn = RaisedButton(
      onPressed: () async {
        log.fine("[_buildCv]onPressed");

        FilePickerResult result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'doc', 'docx', 'odc'],
            withData: true);
        log.fine("[_buildCv]done pick");

        if (result != null && result.count > 0) {
          userData.cv = result.files.first;
          log.fine("[_buildCv]got result ${userData.cv.name}");

          setState(() {
            fieldControler.text = userData.cv.name;
          });
          // User canceled the picker
        }
      },
      child: Text("CV"),
    );

    return Row(children: [Expanded(child: fname), btn]);
  }

  Widget _buildMessage(BuildContext context) {
    log.fine("[_buildMessage] ");

    // should manage editing mode
    TextEditingController controler =
        TextEditingController(text: userData.message);

    return TextFormField(
        readOnly: false,
        textInputAction: TextInputAction.none,
        showCursor: true,
        enabled: true,
        controller: controler,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Message',
        ),
        minLines: 5,
        maxLines: 5,
        onChanged: (String v) {
          this.userData.message = controler.value.text.trim();
        });
  }

  Widget _buildGDPR(BuildContext _context) {
    log.fine("[_buildGDPR] ");

    Widget cb = CheckboxListTile(
      title: Text(AppGlobals.gdpr_message),
      controlAffinity: ListTileControlAffinity.leading,
      value: userData.gdprStatus,
      onChanged: (bool value) {
        setState(() {
          userData.gdprStatus = value;
        });
      },
      dense: true,
    );
    return cb;
  }

  Widget _buildSubmit(BuildContext _context) {
    return ButtonBar(alignment: MainAxisAlignment.start, children: [
      ElevatedButton(
        onPressed: () {
          // Validate returns true if the form is valid, or false
          // otherwise.
          if (_formKey.currentState.validate()) {
            ApplicationRecorder ar =
                ApplicationRecorder(currentCandidate: userData);
            ar.save(_context).then((value) => null);
            // If the form is valid, display a Snackbar.
          }
        },
        child: Text(MaterialLocalizations.of(_context).okButtonLabel),
      )
    ]);
  }

  /// lang fr en
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
  /// check :
  Widget _buildFormWrapper(BuildContext _context) {
    return Form(
        key: _formKey,
        // onChanged: _handleFormChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
            constraints: BoxConstraints.expand(
              width: MediaQuery.of(context).size.width * 0.8,
            ),
            child: ListView(
              children: [
                _buildLang(_context),
                _buildCivilite(_context),
                _buildFirstName(_context),
                _buildLastName(_context),
                _buildEmail(_context),
                _buildPhone(_context),
                _buildCity(_context),
                _buildLinkedIn(_context),
                _buildSalary(_context),
                _buildCv(_context),
                _buildMessage(_context),
                _buildGDPR(_context),
                _buildSubmit(_context),
              ],
            )));
  }

  Widget build(BuildContext _context) {
    Form w = _buildFormWrapper(_context);

    return w;
  }
}
