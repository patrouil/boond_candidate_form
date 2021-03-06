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
 *
 */

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:flutter/cupertino.dart';

typedef LabelGetter<T> = String Function(T value);
typedef IdGetter<T> = int Function(T value);

class BoondDropdownFormField<T> extends StatefulWidget {
  static final Logger log = Logger("BoondDropdownFormField");

  final ValueChanged<T> onChanged;
  final List<T> entries;
  final int selectedId;
  final Function onTap;
  final LabelGetter<T> labelOf;
  final IdGetter<T> idOf;

  final Widget hint;

  /// Default Constructor
  const BoondDropdownFormField(
      {Key key,
      @required this.entries,
      this.selectedId,
      @required this.onChanged,
      this.hint,
      this.onTap,
      this.labelOf,
      this.idOf})
      : assert(entries != null),
        assert(selectedId != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _BoondDropdownFormFieldState<T>();
}

class _BoondDropdownFormFieldState<T> extends State<BoondDropdownFormField> {
  @override
  Widget build(BuildContext c) {
    T selected;

    List<DropdownMenuItem<T>> l = List.empty(growable: true);
    BoondDropdownFormField<T> parent = (this.widget);

    for (T element in parent.entries) {
      // element is of T type.
      // we do not use introspection. Thereby limited to a few class.

      int id = (parent.idOf != null) ? parent.idOf(element) : element.hashCode;
      String value = (parent.labelOf != null)
          ? parent.labelOf(element)
          : element.toString();

      l.add(DropdownMenuItem<T>(value: element, child: Text(value)));
      if (id == parent.selectedId) selected = element;
    }

    return DropdownButtonFormField<T>(
      items: l,
      value: selected,
      hint: (this.widget as BoondDropdownFormField<T>).hint,
      onChanged: (this.widget as BoondDropdownFormField<T>).onChanged,
      onTap: (this.widget as BoondDropdownFormField<T>).onTap,
    );
  }
}
