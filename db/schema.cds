namespace sems.db;

using {
    cuid,
    managed
} from '@sap/cds/common';

type EmployeeStatus     : String enum {
    ACTIVE;
    INACTIVE;
    ON_LEAVE;
    RESIGNED;
};

type LeaveType          : String enum {
    SICK_LEAVE;
    CASUAL_LEAVE;
    EARNED_LEAVE;
    MATERNITY_LEAVE;
    PATERNITY_LEAVE;
    WORK_FROM_HOME;
};

type ApprovalStatus     : String enum {
    PENDING;
    APPROVED;
    REJECTED;
    CANCELLED;
};

type WorkMode           : String enum {
    WFO; // Work From Office
    WFH; // Work From Home
    HYBRID;
};

type ProjectStatus      : String enum {
    PLANNED;
    IN_PROGRESS;
    ON_HOLD;
    COMPLETED;
    CANCELLED;
};

type NotificationStatus : String enum {
    PENDING;
    SENT;
    FAILED;
    READ;
};

type ApiLogStatus       : String enum {
    SUCCESS;
    FAILED;
    TIMEOUT;
    RETRY;
};

type DocumentType       : String enum {
    AADHAR;
    PAN;
    PASSPORT;
    RESUME;
    OFFER_LETTER;
    EXPERIENCE_CERTIFICATE;
    EDUCATION_CERTIFICATE;
};

type Address {
    city    : String(50);
    state   : String(50);
    pincode : String(10);
};

type Skills             : array of String;

entity Employees : cuid, managed {
    empId              : String(10);
    firstName          : String(100);
    lastName           : String(100);
    email              : String(150);
    phone              : String(15);
    address            : Address;
    skills             : Skills;
    designation        : String(100);
    joiningDate        : Date;
    salary             : Decimal(10, 2);
    status             : ProjectStatus default 'ACTIVE';
    department         : Association to Departments;
    manager            : Association to Employees;
    leaveRequests      : Composition of many LeaveRequests
                             on leaveRequests.employee = $self;

    attendanceRecords  : Composition of many Attendance
                             on attendanceRecords.employee = $self;

    documents          : Composition of many Documents
                             on documents.employee = $self;

    notifications      : Composition of many Notifications
                             on notifications.employee = $self;

    projectAssignments : Association to many EmployeeProjects
                             on projectAssignments.employee = $self;
}

entity Departments : cuid, managed {
    deptCode  : String(10);
    deptName  : String(100);
    location  : String(100);
    employees : Association to many Employees
                    on employees.department = $self;
    projects  : Composition of many Projects
                    on projects.department = $self;
}

entity LeaveRequests : cuid, managed {
    leaveType       : LeaveType default 'CASUAL_LEAVE';
    fromDate        : Date;
    toDate          : Date;
    reason          : LargeString;
    approvalStatus  : ApprovalStatus default 'PENDING';
    managerComments : LargeString;
    employee        : Association to Employees;
    approvedBy      : Association to Employees;
}

entity Attendance : cuid, managed {
    attendanceDate : Date;
    checkInTime    : Time;
    checkOutTime   : Time;
    workMode       : WorkMode default 'WFO';
    employee       : Association to Employees;
}

entity Projects : cuid, managed {
    projectCode    : String(20);
    projectName    : String(200);
    startDate      : Date;
    endDate        : Date;
    status         : ProjectStatus default 'IN_PROGRESS';
    department     : Association to Departments;
    projectManager : Association to Employees
                         on projectManager.department = department;
    teamMembers    : Composition of many EmployeeProjects
                         on teamMembers.project = $self;
}

entity EmployeeProjects : cuid, managed {
    allocation    : Integer;
    roleInProject : String(100);
    employee      : Association to Employees;
    project       : Association to Projects;
}

entity AuditLogs {
    key ID            : UUID;
        entityName    : String(100);
        operationType : String(20);
        changedBy     : String(100);
        changedAt     : Timestamp;
        oldValue      : LargeString;
        newValue      : LargeString;
        employee      : Association to Employees
                            on employee.email = changedBy;
}

entity Notifications : cuid, managed {
    notificationType : String(50);
    message          : LargeString;
    status           : NotificationStatus default 'PENDING';
    employee         : Association to Employees;
}

entity Documents : cuid, managed {
    fileName  : String(255);
    mediaType : String(100);
    @Core.MediaType: mediaType
    content   : LargeBinary;
    employee  : Association to Employees;
    Document  : DocumentType default 'AADHAR'
}

entity ApiLogs : cuid, managed {
    apiName         : String(100);
    requestPayload  : LargeString;
    responsePayload : LargeString;
    status          : ApiLogStatus default 'SUCCESS';
    employee        : Association to Employees
                          on employee.createdBy = createdBy;
}