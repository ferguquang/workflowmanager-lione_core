import 'package:workflow_manager/manager/models/response/home_index_response.dart';
import 'package:workflow_manager/procedures/models/response/report_procedure_response.dart';

class ReportProcedureEvent {

  List<WfReport> listWfReport;
  int typeWfTotal;
  int workflowTotal;
  ReportProcedureEvent(this.listWfReport,this.typeWfTotal,this.workflowTotal);

}
