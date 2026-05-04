using {sems.db as db} from '../db/schema';

@impl: 'srv/sems.js'
service semsService {
entity Departments as projection on db.Departments;
entity Employees as projection on db.Employees;
entity LeaveRequests as projection on db.LeaveRequests;
entity Attendance as projection on db.Attendance;
entity Projects as projection on db.Projects;
entity EmployeeProjects as projection on db.EmployeeProjects;
entity Auditlog as projection on db.AuditLogs;
entity Notifications as projection on db.Notifications;
entity Documents as projection on db.Documents;
entity ApiLogs as projection on db.ApiLogs;
action approveLeave(ID : UUID);
action rejectLeave(ID : UUID);
function getEmployeeLeaveBalance(empId : UUID) returns Integer;
}