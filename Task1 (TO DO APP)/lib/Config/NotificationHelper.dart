import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:to_do_app/Config/SQLHelper.dart';
import 'package:to_do_app/Globals/Variables.dart';

class NotificationHelper {
  static Future<void> initilize({required Function? refresh}) async {
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
      debug: false,
    );
    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) async {
        final payload = receivedAction.payload;
        if (payload != null) {
          int id = int.parse(payload['id']!);
          if (receivedAction.buttonKeyPressed == 'complete') {
            await SQLHelper.completeTask(id);
            Print("Completed Task");
            refresh!(null);
          } else if (receivedAction.buttonKeyPressed == 'overdue') {
            final db = await SQLHelper.db();
            await db.update("tasks", {"overdue": 1},
                where: "id = ?", whereArgs: [id]);
            refresh!(null);
          } else if (receivedAction.buttonKeyPressed == 'overduecomplete') {
            final db = await SQLHelper.db();
            await db.delete(
              "tasks",
              where: "overdue = 1",
            );
            refresh!(null);
          }
        }
        print(await SQLHelper.getTasks(null));
      },
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    );
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    Map<String, String?>? data = receivedNotification.payload;
    final db = await SQLHelper.db();
    if (data != null) {
      db.insert("notify", {
        "notId": data['notId'],
        "desc": receivedNotification.title,
        "ddate": data['date'],
        "dtime": data['time']
      });
    }
    print(await SQLHelper.getTasks(null));
    print(await SQLHelper.getNotifications());
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  static Future<void> cancleNotification(int id) async {
    await AwesomeNotifications().cancel(id);
    Print("Notification Cancled");
  }

  static Future<void> sendNotificationsNow(
      int id, String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'high_importance',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        locked: false,
      ),
    );
  }

  static Future<void> sendNotification({
    required final int notId,
    required final String title,
    required final String body,
    final String? summary,
    final ActionType actionType = ActionType.Default,
    final Map<String, String>? payload,
    final String? repeteType,
    final List<NotificationActionButton>? actionButtons,
    required final DateTime notificationDateTime,
  }) async {
    if (repeteType == null) {
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
    } else if (repeteType == "Daily") {
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
          schedule: NotificationAndroidCrontab.daily(
              referenceDateTime: notificationDateTime));
    } else if (repeteType == "Hourly") {
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
          schedule: NotificationAndroidCrontab.hourly(
              referenceDateTime: notificationDateTime));
    } else if (repeteType == "Weakly") {
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
          schedule: NotificationAndroidCrontab.weekly(
              referenceDateTime: notificationDateTime));
    }
  }
}
