import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/data/city_model.dart';
import 'package:skoomin/src/data/country_model.dart';
import 'package:skoomin/src/data/notifier.dart';
import 'package:skoomin/src/data/school_model.dart';
import 'package:skoomin/src/data/states_model.dart';
import 'package:skoomin/src/services/city_services.dart';
import 'package:skoomin/src/services/connectivity_services.dart';
import 'package:skoomin/src/services/country_services.dart';
import 'package:skoomin/src/services/school_services.dart';
import 'package:skoomin/src/services/states_services.dart';
import 'package:skoomin/src/ui/pages/student_registration_page.dart';
import 'package:skoomin/src/ui/widgets/app_text_field.dart';
import 'package:skoomin/src/ui/widgets/auth_button.dart';
import 'package:skoomin/src/ui/widgets/dropdown_widget.dart';
import '../modals/dialog.dart' as prefix0;
import 'package:reusables/reusables.dart';

class SchoolSelectionView extends ControlledWidget<Notifier> {
  const SchoolSelectionView({Key? key, required this.notifier})
      : super(key: key, controller: notifier);
  final Notifier notifier;

  @override
  createState() => _SchoolSelectionVIewState();
}

class _SchoolSelectionVIewState extends State<SchoolSelectionView>
    with ControlledStateMixin {
  int _len = 1;
  var _secretEnabled = false;
  late bool obscurePassword;

  GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();
  List<Widget> _actions = [];

  // List<String?> _values = List.filled(5, null, growable: false);
  //
  final List<String?> _values = List.generate(5, (index) => null);

  var _countryIds = <String>[];
  var _countryNames = <String>[];

  var _stateIds = <String>[];
  var _stateNames = <String>[];

  var _cityIds = <String>[];
  var _cityNames = <String>[];

  var _schoolIds = <String>[];
  var _schoolNames = <String>[];

  TextEditingController _secretCodeController = TextEditingController();

  // var listC;
  //
  Future<List<CountryModel>> fetchCountries() async =>
      CountryServices().fetch();

  //
  Future<List<StatesModel>> fetchStates(String id) async =>
      await StatesServices().fetchSelected(id, 'countryId');

  //
  Future<List<CityModel>> fetchCities(String id) async =>
      await CityServices().fetchSelected(id, 'stateId');

  Future<List<SchoolModel>> fetchSchools(String id) async =>
      await SchoolServices().fetchSelected(id, 'cityId');

  @override
  void initState() {
    obscurePassword = true;

    fetchCountries().then((f) {
      var countryIds = <String>[];
      var countryNames = <String>[];

      for (var data in f) {
        countryIds.add(data.id!);
        countryNames.add(data.name);
      }

      setState(() {
        _countryIds = countryIds;
        _countryNames = countryNames;
      });
    });
    super.initState();
    debugPrint('$_secretEnabled');
  }

  @override
  Widget build(context) {
    _actions = [
      DropDownWidget(
        after: () =>
            fetchStates(_countryIds[_countryNames.indexOf(_values[0]!)])
                .then((f) {
          var stateIds = <String>[];
          var stateNames = <String>[];

          for (var data in f) {
            stateIds.add(data.id!);
            stateNames.add(data.name);
          }
          setState(() {
            _stateIds = stateIds;
            _stateNames = stateNames;
          });
        }),
        //String to get selected value - 1st bool - secret enabled - 2nd bool _enabled - _key - len

        callBack: (selectedValue, controller, secretEnable, enabled, key, len) {
          _values[0] = selectedValue;
          _secretCodeController = controller;
          _secretEnabled = secretEnable;
          widget.controller.change(enabled);
          _key = key;
          _len = len;
        },
        index: 0,
        items: _countryNames,
        type: "country",
        values: _values,
        len: _len,
        key2: _key,
      ),

      DropDownWidget(
        after: () =>
            fetchCities(_stateIds[_stateNames.indexOf(_values[1]!)]).then((f) {
          var cityIds = <String>[];
          var cityNames = <String>[];

          for (var data in f) {
            cityIds.add(data.id!);
            cityNames.add(data.name);
          }

          setState(() {
            _cityIds = cityIds;
            _cityNames = cityNames;
          });
        }),
        callBack: (selectedValue, controller, secretEnable, enabled, key, len) {
          _values[1] = selectedValue;
          _secretCodeController = controller;
          _secretEnabled = secretEnable;
          widget.controller.change(enabled);
          _key = key;
          _len = len;
        },
        index: 1,
        items: _stateNames,
        type: 'state',
        values: _values,
        len: _len,
        key2: _key,
      ),

      DropDownWidget(
        after: () =>
            fetchSchools(_cityIds[_cityNames.indexOf(_values[2] ?? '')])
                .then((f) {
          var schoolIds = <String>[];
          var schoolNames = <String>[];

          for (var data in f) {
            schoolIds.add(data.id!);
            schoolNames.add(data.name);
          }

          setState(() {
            _schoolIds = schoolIds;
            _schoolNames = schoolNames;
          });
        }),
        callBack: (selectedValue, controller, secretEnable, enabled, key, len) {
          _values[2] = selectedValue;
          _secretCodeController = controller;
          _secretEnabled = secretEnable;
          widget.controller.change(enabled);
          _key = key;
          _len = len;
        },
        index: 2,
        items: _cityNames,
        type: 'city',
        values: _values,
        len: _len,
        key2: _key,
      ),

      //

      DropDownWidget(
        after: () {
          _values[4] = _schoolIds[_schoolNames.indexOf(_values[3]!)];
          _secretEnabled = true;
        },
        callBack: (selectedValue, controller, secretEnable, enabled, key, len) {
          _values[3] = selectedValue;
          _secretCodeController = controller;
          _secretEnabled = secretEnable;
          widget.controller.change(enabled);
          _key = key;
          _len = len;
        },
        index: 3,
        items: _schoolNames,
        type: 'school',
        values: _values,
        len: _len,
        key2: _key,
      ),

      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: AppPasswordField(
          textEditingController: _secretCodeController,
          label: 'Secret Code',
          icon: Icons.lock,
          onChanged: (value) {
            if (value != '') {
              if (value.length >= 4) {
                widget.controller.change(true);
              } else {
                widget.controller.change(false);
              }
            } else {
              widget.controller.change(false);
            }
          },
        ),
      )
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            child: AnimatedList(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              key: _key,
              shrinkWrap: true,
              initialItemCount: 1,
              itemBuilder: (context, index, anim) => SizeTransition(
                sizeFactor: anim,
                child: _actions[index],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 90, right: 90),
            child: AuthButton(
              radius: 2,
              height: 38,
              width: 240,
              text: 'Done',
              onTap: widget.controller.enable
                  ? () async {
                      if (!await ConnectivityServices().getNetworkStatus()) {
                        prefix0.showConnectionErrorDialog(context);
                        return;
                      }
                      if (_secretCodeController.text.isNotEmpty) {
                        prefix0.getLoadingDialog(
                          context: context,
                          loadingMessage: 'Checking provided Info...',
                        );
                        _checkSchoolInformation().then(
                          (f) {
                            Navigator.of(context).pop();
                            if (!f) {
                              prefix0.getDialog(
                                context: context,
                                contentWidget: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "The School Info you entered is incorrect.",
                                        softWrap: true,
                                      ),
                                    )
                                  ],
                                ),
                                title: "Error",
                                actions: [
                                  TextButtonWidget(
                                    title: "Ok",
                                    onPressed: () => AppNavigation.pop(context),
                                  )
                                ],
                              );
                            } else {
                              AppNavigation.pop(context);
                              AppNavigation.to(
                                context,
                                StudentRegistrationPage(
                                  schoolId: _schoolIds[
                                      _schoolNames.indexOf(_values[3]!)],
                                ),
                              );
                            }
                          },
                        );
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _checkSchoolInformation() async {
    var snap = await FirebaseFirestore.instance
        .collection('Schools_')
        .doc(_schoolIds[_schoolNames.indexOf(_values[3]!)])
        .get();
    return snap.data()!["secretCode"] == _secretCodeController.text;
  }
}
