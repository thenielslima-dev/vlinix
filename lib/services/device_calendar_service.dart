import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;

class DeviceCalendarService {
  DeviceCalendarService._();

  static Future<bool> openCalendarInvite({
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    String fileName = 'vlinix-appointment.ics',
  }) async {
    final ics = _buildIcs(
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
    );

    if (kIsWeb) {
      final blob = html.Blob([ics], 'text/calendar;charset=utf-8');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..download = fileName
        ..click();
      html.Url.revokeObjectUrl(url);
      return true;
    }

    final uri = Uri.dataFromString(
      ics,
      mimeType: 'text/calendar',
      encoding: utf8,
    );

    if (!await canLaunchUrl(uri)) {
      return false;
    }

    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static String _buildIcs({
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
  }) {
    final now = _formatUtc(DateTime.now());
    final start = _formatUtc(startTime);
    final end = _formatUtc(endTime);
    final uid = 'vlinix-${startTime.microsecondsSinceEpoch}@vlinix';

    return [
      'BEGIN:VCALENDAR',
      'VERSION:2.0',
      'PRODID:-//Vlinix//Appointments//EN',
      'BEGIN:VEVENT',
      'UID:$uid',
      'DTSTAMP:$now',
      'DTSTART:$start',
      'DTEND:$end',
      'SUMMARY:${_escape(title)}',
      'DESCRIPTION:${_escape(description)}',
      'END:VEVENT',
      'END:VCALENDAR',
    ].join('\r\n');
  }

  static String _formatUtc(DateTime value) {
    final utc = value.toUtc();
    String two(int number) => number.toString().padLeft(2, '0');
    return '${utc.year}${two(utc.month)}${two(utc.day)}T'
        '${two(utc.hour)}${two(utc.minute)}${two(utc.second)}Z';
  }

  static String _escape(String value) {
    return value
        .replaceAll(r'\', r'\\')
        .replaceAll('\n', r'\n')
        .replaceAll(',', r'\,')
        .replaceAll(';', r'\;');
  }
}
