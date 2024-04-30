import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationHelper {
  static Future<void> initilize() async {
    tz.initializeTimeZones();
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'high_importance',
            channelName: 'Basic',
            channelDescription: 'channelDescription',
            importance: NotificationImportance.Max,
            onlyAlertOnce: false,
            playSound: true)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'high_imp_group', channelGroupName: 'Group1'),
      ],
      debug: true,
    );
    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    );
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    final payload = receivedAction.payload ?? {};
    if (receivedAction.buttonKeyPressed == 'key1') {
      payload.forEach((key, value) async {});
    } else if (receivedAction.buttonKeyPressed == 'key') {
      payload.forEach((key, value) async {});
    }
  }

  static Future<void> sendNotification({
    required final int notId,
    required final String title,
    required final String body,
    final String? summary,
    final ActionType actionType = ActionType.Default,
    final Map<String, String>? payload,
    final List<NotificationActionButton>? actionButtons,
    required final DateTime notificationDateTime,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notId,
        channelKey: 'high_importance',
        title: title,
        body: body,
        actionType: actionType,
        payload: payload,
        notificationLayout: NotificationLayout.Default,
        summary: summary,
        locked: true,
      ),
      actionButtons: actionButtons,
      schedule: NotificationCalendar(
        year: notificationDateTime.year,
        month: notificationDateTime.month,
        day: notificationDateTime.day,
        hour: notificationDateTime.hour,
        minute: notificationDateTime.minute,
        second: 0,
        millisecond: 0,
      ),
    );
  }
}
