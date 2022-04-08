import 'package:intl/intl.dart';

String getFormatedDate(DateTime date) =>
    date.day.toString() +
    "-" +
    [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ][date.month - 1] +
    "-" +
    date.year.toString();

String timeFormat(DateTime time) => DateFormat('hh:mm a').format(time);

String dateAndTimeFormat(DateTime time) =>
    DateFormat('dd-MMM-yyyy hh:mm a').format(time);

String? oldPasswordValidator(String? value, String oldPassword) =>
    value!.isEmpty
        ? 'Enter old password'
        : value.length < 6
            ? 'Password must be 6 characters long'
            : oldPassword != value
                ? 'Entered old password is not correct'
                : null;

String? newPasswordValidator(String? value, String oldPassword) =>
    value!.isEmpty
        ? 'Enter old password'
        : value.length < 6
            ? 'Password must be 6 characters long'
            : oldPassword == value
                ? 'New password must be different from old password'
                : null;
