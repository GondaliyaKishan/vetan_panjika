class UrlController {
  String adminLoginUrl = "/api/api/AdminMobileLogin/AdminMobileUserLogin";
  String adminAutoLoginUrl = "/api/api/AutoLogin/AutoLogin";
  String imgUrl = "/api/Documents/";
  String attendanceImgUrl = "/api/AttendanceLogs/";
  String signUpOtpSend =
      "/api/api/SendMobileOTPForRegistration/SendMobileOTPForRegistration";
  String signUpOtpVerify =
      "/api/api/SendMobileOTPForRegistration/MobileRegistrationOTPVerify";

  // offline
  String appCode = "08796725-DA15-454A-B33A-E296D5C559D9";
  String checkConfig =
      "/api/api/MobileUserLogin/ServerSettingsVerification?AppCode=";
  String employeeLoginInfoUrl =
      "/api/api/MobileUserLogin/MobileUserDetails?AppCode=";
  String syncAttendanceUrl = "/api/api/Attendance/AttendanceMark";

  // employee mark attendance url
  String employeePunchInUrl =
      "/api/api/MobileAttendance/MobileAttendanceLogInsert";

  // employee profile pic upload
  String employeeProfileUpload =
      "/api/api/MobileEmployee/MobileProfilePicUpdate";

  // admin dashboard data url
  String adminDashboardUrl =
      "/api/api/MobileDashboard/MobileTodayAttendanceStatistics_Admin";
  String adminDashboardDeviceChartUrl = "/api/api/MobileDashboard/MobileNMSDashboardData";
  String adminDashboardLeavesUrl = "/api/api/MobileDashboard/MobileLeavesDashboardData";
  String adminDashboardExpensesUrl = "/api/api/MobileDashboard/MobileExpensesDashboardData";

  // admin dashboard pages url
  String adminBranchesUrl = "/api/api/MobileBranch/MobileBranchList";
  String adminDevicesUrl = "/api/api/MobileDevice/MobileDeviceList";
  String adminEmployeesUrl = "/api/api/MobileEmployee/MobileEmployeeList?";
  String adminHolidayUrl = "/api/api/MobileHoliday/MobileHolidayList?Year=";

  // admin employee attendance reports
  String employeeWiseReportUrl =
      "/api/api/MobileAttendanceEmployeeWise/Admin_AttendanceEmployeeWiselist?";
  String employeeDateWiseReportUrl =
      "/api/api/MobileAttendanceEmployeeWise/Admin_MobileAttendanceEmployeeData?";
  String dayWiseReportUrl =
      "/api/api/MobileAttendanceEmployeeWise/Admin_AttendanceDayWiselist?";

  // admin access control url
  String doorLocksUrl = "/api/api/Dashboard/DashboardDoorLock";
  String doorOpenClose = "/api/api/Device/DoorLockFunctions?";

  // admin dashboard page filters url
  String branchesFilter = "/api/api/MobileBranch/DropDownBranchList";
  String devicesFilter = "/api/api/MobileDevice/DropDownDeviceList";
  String employeeFilter =
      "/api/api/MobileEmployee/MobileEmployeeList?DeviceID=&TypeID=&StatusID=1";

  // employee dashboard pages url
  String employeeDashboardUrl =
      "/api/api/MobileDashboard/ThisMonthAttendance_Employee?";
  String employeeDashboardLogsUrl =
      "/api/api/MobileDashboard/EmployeeTodayLogs?";

  // personal info url
  String employeePersonalInfoUrl =
      "/api/api/EmployeePersonalDetails/MobileEmployeeList?";
  // attendance urls
  String employeeAttendanceLogUrl =
      "/api/api/MobileAttendanceEmployeeWise/MobileAttendanceEmployeeWiselist";
  String employeeAttendanceLogDateWiseUrl =
      "/api/api/MobileAttendanceEmployeeWise/MobileAttendanceEmployeeData?DateOld=";
  // expenses urls
  String employeeExpensesListUrl =
      "/api/api/MobileExpenses/MobileExpencesList";
  String employeeExpensesByIdUrl =
      "/api/api/MobileExpenses/MobileExpencesListByID?ID=";
  String employeeExpenseAddEditUrl = "/api/api/MobileExpenses/ExpensesAddEdit";

  // daily updates urls
  String employeeUpdatesListUrl =
      "/api/api/MobileDailyUpdates/MobileDailyUpdatesList";
  String employeeUpdatesByIdUrl =
      "/api/api/MobileDailyUpdates/MobileDailyUpdatesListByID?ID=";
  String employeeUpdatesAddEditUrl = "/api/api/MobileDailyUpdates/DailyUpdatesAddEdit";

  // allowances urls
  String employeeAllowancesListUrl =
      "/api/api/MobilePayrollAllowances/GetMobilePayrollAllowancesList";
  String employeeAllowancesByIdUrl =
      "/api/api/MobilePayrollAllowances/MobilePayrollAllowancesListByID?ID=";
  String employeeAllowancesAddEditUrl = "/api/api/MobilePayrollAllowances/PayrollAllowancesAddEdit";

  // employee filters
  // expenses type filter
  String expenseTypeFilterUrl = "/api/api/MobileExpenses/ExpensesTypeList?";
  // expenses subtype filter
  String expenseSubtypeFilterUrl = "/api/api/MobileExpenses/ExpensesSubTypeList?";
  // allowances type filter
  String allowanceTypeFilterUrl = "/api/api/MobilePayrollAllowances/GetAllowancesHeadList?";

  // leave urls
  String employeeLeaveListUrl =
      "/api/api/MobileMarkLeave/MobileMarkleaveList";
  String employeeLeaveAddEditUrl = "/api/api/MobileMarkLeave/MobileMarkleaveAddEdit";
  // leave type filters
  String leaveTypeFilterUrl = "/api/api/MobileMarkLeave/leavetypeList?";

  // get project name filters
  String projectNameFilterUrl = "/api/api/MobileDailyUpdates/MobileProjectList?";

  //// -----     NMS urls     ----- ////
  String nmsDashboardDataUrl = "/api/api/NMSDashBoard/MobileDashboardData";
  String nmsSearchUrl = "/api/api/Hosts/DevicesSearchBySingleValue?Criteria=";
  String nmsOverviewDataUrl = "/api/api/HostTypeWise/MobileDeviceTypeWiseOverview?";
  String nmsAgentsListUrl = "/api/api/AgentDashoard/AgentDashboardData";
  String nmsLocationViewUrl = "/api/api/LocationWise/MobileLocationsOverview?AgentID=";
  String nmsDeviceViewUrl = "/api/api/HostTypeWise/MobileDeviceTypeWiseSummary?AgentID=0&LocationID=0&DevicesTypeID=0";
  String nmsAssetSummaryUrl = "/api/api/Inventory/InvetoryChartList?AgentID=";

  //// ----- NMS single details url ----- ////
  String nmsAgentDetailsUrl = "/api/api/SingleAgentView/SingleAgentViewList?id=";
  String nmsDeviceDetailsUrl = "/api/api/SingleHostView/MobileHostsSingleIPViewList?id=";

  //// ---- NMS type wise url ---- ////
  String nmsLocationWiseDevicesUrl = "/api/api/LocationWise/LocationWiseTypeWiseDataSummaryMobileList?id=";
  String nmsDeviceTypeWiseDevicesUrl = "/api/api/LocationWise/LocationWiseTypeWiseDataSummaryMobileList?AgentID=";

  //// ----- NMS filters urls ----- ////
  String nmsAgentFilterUrl = "/api/api/Agent/MobileAgentList";
  String nmsDeviceTypeFilterUrl = "/api/api/DeviceType/DeviceTypeFilterList";
  String nmsLocationFilterUrl = "/api/api/Location/MobileLocationList?id=";

}
