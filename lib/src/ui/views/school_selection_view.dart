import 'package:flutter/material.dart';
import 'package:skoomin/src/data/city_model.dart';
import 'package:skoomin/src/data/country_model.dart';
import 'package:skoomin/src/data/notifier.dart';
import 'package:skoomin/src/data/school_model.dart';
import 'package:skoomin/src/data/states_model.dart';
import 'package:skoomin/src/services/city_services.dart';
import 'package:skoomin/src/services/country_services.dart';
import 'package:skoomin/src/services/school_services.dart';
import 'package:skoomin/src/services/states_services.dart';
import 'package:skoomin/src/ui/widgets/app_text_field.dart';
import 'package:skoomin/src/ui/widgets/drop_down_widget.dart';

class SchoolSelectionView extends StatefulWidget {
  const SchoolSelectionView({
    Key? key,
    required this.notifier,
  }) : super(key: key);

  final Notifier notifier;

  @override
  _SchoolSelectionViewState createState() => _SchoolSelectionViewState();
}

class _SchoolSelectionViewState extends State<SchoolSelectionView> {
  late Widget _countryDropDown;
  CountryModel? _selectedCountry;
  StatesModel? _selectedState;
  CityModel? _selectedCity;
  SchoolModel? _selectedSchool;
  var _secretEnabled = false;
  var obscurePassword = true;
  final _secretCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _countryDropDown = FutureDropDownWidget<CountryModel>(
      dataFunction: CountryServices().fetch,
      value: _selectedCountry,
      hintText: 'Please select your country',
      onChanged: (value) {
        _selectedCountry = value;
        _selectedState = null;
        _selectedCity = null;
        _selectedSchool = null;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(children: [
        _countryDropDown,
        if (_selectedCountry != null)
          FutureDropDownWidget<StatesModel>(
            dataFunction: () => StatesServices().fetchSelected(
              _selectedCountry!.id!,
              'countryId',
            ),
            value: _selectedState,
            onChanged: (value) {
              _selectedState = value;
              _selectedCity = null;
              _selectedSchool = null;
              setState(() {});
            },
          ),
        if (_selectedState != null)
          FutureDropDownWidget<CityModel>(
            dataFunction: () => CityServices().fetchSelected(
              _selectedState!.id!,
              'stateId',
            ),
            value: _selectedCity,
            onChanged: (value) {
              _selectedCity = value;
              _selectedSchool = null;
              setState(() {});
            },
          ),
        if (_selectedCity != null)
          FutureDropDownWidget<SchoolModel>(
            dataFunction: () => SchoolServices().fetchSelected(
              _selectedCity!.id!,
              'cityId',
            ),
            value: _selectedSchool,
            onChanged: (value) {
              _selectedSchool = value;
              setState(() {});
            },
          ),
        if (_selectedSchool != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: AppPasswordField(
              textEditingController: _secretCodeController,
              label: 'Secret Code',
              icon: Icons.lock,
              onChanged: (value) {
                if (value != '') {
                  //   if (value.length >= 4) {
                  //     widget.controller.change(true);
                  //   } else {
                  //     widget.controller.change(false);
                  //   }
                  // } else {
                  //   widget.controller.change(false);
                }
              },
            ),
          ),
      ]),
    );
  }
}
//       Padding(
//         padding: const EdgeInsets.only(top: 8.0),
//         child: AppPasswordField(
//           textEditingController: _secretCodeController,
//           label: 'Secret Code',
//           icon: Icons.lock,
//           onChanged: (value) {
//             if (value != '') {
//               if (value.length >= 4) {
//                 widget.controller.change(true);
//               } else {
//                 widget.controller.change(false);
//               }
//             } else {
//               widget.controller.change(false);
//             }
//           },
//         ),
//       )
//     ];
//
//           Padding(
//             padding: const EdgeInsets.only(top: 30.0, left: 90, right: 90),
//             child: AuthButton(
//               radius: 2,
//               height: 38,
//               width: 240,
//               text: 'Done',
//               onTap: widget.controller.enable
//                   ? () async {
//                       if (!await ConnectivityServices().getNetworkStatus()) {
//                         prefix0.showConnectionErrorDialog(context);
//                         return;
//                       }
//                       if (_secretCodeController.text.isNotEmpty) {
//                         prefix0.getLoadingDialog(
//                           context: context,
//                           loadingMessage: 'Checking provided Info...',
//                         );
//                         _checkSchoolInformation().then(
//                           (f) {
//                             Navigator.of(context).pop();
//                             if (!f) {
//                               prefix0.getDialog(
//                                 context: context,
//                                 contentWidget: Row(
//                                   children: const [
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Icon(
//                                         Icons.error,
//                                         color: Colors.red,
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Text(
//                                         "The School Info you entered is incorrect.",
//                                         softWrap: true,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 title: "Error",
//                                 actions: [
//                                   TextButtonWidget(
//                                     title: "Ok",
//                                     onPressed: () => AppNavigation.pop(context),
//                                   )
//                                 ],
//                               );
//                             } else {
//                               AppNavigation.pop(context);
//                               AppNavigation.to(
//                                 context,
//                                 StudentRegistrationPage(
//                                   schoolId: _schoolIds[
//                                       _schoolNames.indexOf(_values[3]!)],
//                                 ),
//                               );
//                             }
//                           },
//                         );
//                       }
//                     }
//                   : null,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<bool> _checkSchoolInformation() async {
//     var snap = await FirebaseFirestore.instance
//         .collection('Schools_')
//         .doc(_schoolIds[_schoolNames.indexOf(_values[3]!)])
//         .get();
//     return snap.data()!["secretCode"] == _secretCodeController.text;
//   }
// }
