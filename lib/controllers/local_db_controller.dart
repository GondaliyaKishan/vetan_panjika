import 'dart:developer';

import '../common/database_helper.dart';
import '../model/employee_models/offline_logs_model.dart';

class LocalDBController {

  Future<OfflineLogsResponseDataModel?> getAttendanceLogsLocal() async {
    try {
      LocalDB _localDB = LocalDB();
      await _localDB.getDB();
      List logs = [];
      logs = await _localDB.getDataTable(queryForDB: "select * FROM attendance_logs");
      if (logs.isNotEmpty) {
        Map<String, dynamic> data = {};
        data.addAll({"OfflineLogsData": logs});
        var attendanceData = OfflineLogsResponseDataModel.fromJson(data);
        return attendanceData;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
    return null;
  }

}