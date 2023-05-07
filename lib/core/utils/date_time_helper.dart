import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

DateTime convertSecondsToDateTime(int seconds) {
  // We have to multiply the timestamp input by 1000 because
  // DateTime.fromMillisecondsSinceEpoch expects milliseconds but we use seconds.
  return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
}

String currentDateAsJalali() {
  Jalali jalali = DateTime.now().toJalali();
  return '${jalali.year}/${jalali.month}/${jalali.day}';
}

DateTime parseStringToDateTime(String datetimeAsString) {
  return DateFormat("yyyy-MM-dd hh:mm:ss").parse(datetimeAsString);
}

String parseStringToFormattedJalali(String datetimeAsString) {
  DateTime dateTime = DateTime.parse(datetimeAsString);
  Jalali jalali = dateTime.toJalali();
  String formatted = '${jalali.year}/${jalali.month}/${jalali.day} - ${DateFormat('H:m a').format(dateTime)}';
  // return DateFormat("yyyy-MM-dd hh:mm:ss").parse(datetimeAsString);
  return formatted;
}

/// convert Datetime as String to form of String that you want
/// arguments:
///   String formatted Datetime
///   String mode
///     mode 'a' => year/month/day
///     mode 'y' => year
///     mode 'm' => month
///     mode 'd' => day
String parseFormattedStringToJalali(String formattedString, {String mode = 'a'}) {
  Jalali jalali = DateTime.parse(formattedString).toJalali();

  if (mode == 'a') {
    return '${jalali.year}/${jalali.month}/${jalali.day}';
  } else if (mode == 'y') {
    return jalali.year.toString();
  } else if (mode == 'm') {
    return jalali.month.toString();
  } else if (mode == 'd') {
    return jalali.day.toString();
  } else if (mode == 'md') {
    return '${jalali.month} / ${jalali.day}';
  } else {
    return '';
  }
}

/// Good morning
/// 12 AM to 11:59 AM
/// (12 to 11:59) in 24 hour format
///
/// Good afternoon
/// 12 PM to 4:59 PM
/// (24 to 16:59) in 24 hour format
///
/// Good evening
/// 5 PM to 7:59 PM
/// (17 to 19:59) in 24 hour format
///
/// Good night
/// 8 PM to 11:59 PM
/// (20 to 22:59) in 24 hour format
String timeOfDay() {
  int hour = int.parse(DateFormat('HH').format(DateTime.now()));
  if (hour >= 5 && hour < 12) {
    return 'Good Morning';
  } else if (hour >= 12 && hour < 17) {
    return 'Good Afternoon';
  } else if (hour >= 17 && hour < 20) {
    return 'Good Evening';
  } else {
    return 'Good Night';
  }
}

bool isDay(int sunriseTimestamp, sunsetTimestamp) {
  DateTime sunriseDateTime = DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000, isUtc: true);
  DateTime sunsetDateTime = DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000, isUtc: true);

  int sunriseHour = int.parse(DateFormat('H').format(sunriseDateTime));
  int sunsetHour = int.parse(DateFormat('H').format(sunsetDateTime));

  int hour = int.parse(DateFormat('H').format(DateTime.now()));

  if (hour >= sunriseHour && hour < sunsetHour) {
    return true;
  } else if (hour >= sunsetHour) {
    return false;
  } else {
    return false;
  }
}

String convertTimestampToHmFormattedString(int timestamp){
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
  return '${DateFormat('Hm').format(dateTime)} ${DateFormat('a').format(dateTime)}';
}

String convertMillisecondsTimestampToJalaliFormattedString(int milliseconds, String format) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  Jalali jalali = dateTime.toJalali();
  String formattedTime = DateFormat(format).format(dateTime);

  return '${jalali.year}/${jalali.month}/${jalali.day} - $formattedTime';
}

/*
ICU Name                   Skeleton
 --------                   --------
 DAY                          d
 ABBR_WEEKDAY                 E
 WEEKDAY                      EEEE
 ABBR_STANDALONE_MONTH        LLL
 STANDALONE_MONTH             LLLL
 NUM_MONTH                    M
 NUM_MONTH_DAY                Md
 NUM_MONTH_WEEKDAY_DAY        MEd
 ABBR_MONTH                   MMM
 ABBR_MONTH_DAY               MMMd
 ABBR_MONTH_WEEKDAY_DAY       MMMEd
 MONTH                        MMMM
 MONTH_DAY                    MMMMd
 MONTH_WEEKDAY_DAY            MMMMEEEEd
 ABBR_QUARTER                 QQQ
 QUARTER                      QQQQ
 YEAR                         y
 YEAR_NUM_MONTH               yM
 YEAR_NUM_MONTH_DAY           yMd
 YEAR_NUM_MONTH_WEEKDAY_DAY   yMEd
 YEAR_ABBR_MONTH              yMMM
 YEAR_ABBR_MONTH_DAY          yMMMd
 YEAR_ABBR_MONTH_WEEKDAY_DAY  yMMMEd
 YEAR_MONTH                   yMMMM
 YEAR_MONTH_DAY               yMMMMd
 YEAR_MONTH_WEEKDAY_DAY       yMMMMEEEEd
 YEAR_ABBR_QUARTER            yQQQ
 YEAR_QUARTER                 yQQQQ
 HOUR24                       H
 HOUR24_MINUTE                Hm
 HOUR24_MINUTE_SECOND         Hms
 HOUR                         j
 HOUR_MINUTE                  jm
 HOUR_MINUTE_SECOND           jms
 HOUR_MINUTE_GENERIC_TZ       jmv   (not yet implemented)
 HOUR_MINUTE_TZ               jmz   (not yet implemented)
 HOUR_GENERIC_TZ              jv    (not yet implemented)
 HOUR_TZ                      jz    (not yet implemented)
 MINUTE                       m
 MINUTE_SECOND                ms
 SECOND                       s
 */
