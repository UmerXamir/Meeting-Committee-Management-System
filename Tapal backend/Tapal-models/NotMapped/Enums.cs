using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tapal_models.NotMapped
{
    public class Enums
    {
        public static readonly string CONTEXT_USER = "User";

        public enum Status
        {
            Active = 1,
            Inactive = 2,
            Deleted = 3,
            Archived = 4
        }

        public enum Progress
        {
            Draft = 5,
            InApproval = 6,
            Approved = 7,
            Rejected = 8,
            OnHold = 9
        }

        public enum CustomClaimType
        {
            UserName,
            UserEmail,
            UserId,
            ClientId,
            ClientReferenceKey,
            RefreshToken,
            FeaturePermissions,
            DataPermissions,
            ReportPermissions,
            DepartmentId,
            DepartmentName,
            DepartmentCode,
            DepartmentInitials,
            OrganizationHierarchyId,
            OrganizationHierarchyName,
            OrganizationHierarchyDescription,
            ReportingToId,
            ReportingToName,
            UserSecurityGroupName,
        }


        // FOR RCSA RISK
        public enum RcsaAction
        {
            Submit,
            Revert,
            Accept,
            Approve,
        }

        public enum RcsaProgress
        {
            PendingAtORMMaker,
            PendingAtBusinessChecker,
            RevertedToORMMaker,
            PendingAtORMChecker,
            Completed
        }

        public enum Role
        {
            OrmMaker,
            OrmChecker,
            BusinessMaker,
            BusinessChecker,
        }

        // FOR INCIDENT

        public enum IncidentAttachmentType
        {
            IncidentDocumentReferenceType,
            IncidentAttachmentReferenceType,
        }

        public enum AttachmentReferenceType
        {
            IncidentDocument,
            IncidentAttachment,
            IncidentActionPlan,
            IncidentRecovery,
            Default
        }

        public enum RuleConfigurationPriorityOrProgress
        {
            RuleDepartment,
            RuleAmountRange
        }


        // DASHBOARD
        public enum IncidentDashboardCategory
        {
            IncidentType,
            IncidentSeverity,
            IncidentDepartment
        }

        public enum IncidentActionPlansDashboardCategory
        {
            IncidentActionPlanStatus,
            IncidentActionPlanDepartment,
            IncidentActionPlanAssignee,
            IncidentActionPlanByTimeLine
        }
    }
}
