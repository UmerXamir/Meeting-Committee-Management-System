using Microsoft.EntityFrameworkCore;
using System.Net.Mail;
using Tapal_models.Models;
using Attachment = Tapal_models.Models.Attachment;

namespace Tapal_Repositories.Context
{
    public class TapalContext : DbContext
    {
        public TapalContext(DbContextOptions<TapalContext> options) : base(options) { }

        // DbSets
        public DbSet<User> Users { get; set; } = null!;
        public DbSet<Role> Roles { get; set; } = null!;
        public DbSet<UserRole> UserRoles { get; set; } = null!;
        public DbSet<Committee> Committees { get; set; } = null!;
        public DbSet<CommitteeMember> CommitteeMembers { get; set; } = null!;
        public DbSet<Department> Departments { get; set; } = null!;
        public DbSet<DepartmentUser> DepartmentUsers { get; set; } = null!;
        public DbSet<Meeting> Meeting { get; set; } = null!;
        public DbSet<MeetingAttendee> MeetingAttendees { get; set; } = null!;
        public DbSet<AgendaItem> AgendaItems { get; set; } = null!;
        public DbSet<AgendaWorkFlow> AgendaWorkflows { get; set; } = null!;
        public DbSet<Attachment> Attachments { get; set; } = null!;
        public DbSet<Comment> Comments { get; set; } = null!;
        public DbSet<Votes> Votes { get; set; } = null!;
        public DbSet<ActionItem> ActionItems { get; set; } = null!;
        public DbSet<MeetingMinute> MeetingMinutes { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Users
            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("users");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.Name).HasColumnName("name");
                entity.Property(e => e.Email).HasColumnName("email");
                entity.Property(e => e.PasswordHash).HasColumnName("password_hash");
                entity.Property(e => e.RoleId).HasColumnName("role_id");
            });

            // Roles
            modelBuilder.Entity<Role>(entity =>
            {
                entity.ToTable("roles");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.Name).HasColumnName("name");
                entity.Property(e => e.Description).HasColumnName("description");
            });

            // UserRoles
            modelBuilder.Entity<UserRole>(entity =>
            {
                entity.ToTable("user_roles");
                entity.HasKey(e => new { e.UserId, e.RoleId });
                entity.Property(e => e.UserId).HasColumnName("user_id");
                entity.Property(e => e.RoleId).HasColumnName("role_id");
            });

            // Committees
            modelBuilder.Entity<Committee>(entity =>
            {
                entity.ToTable("committees");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.Name).HasColumnName("name");
                entity.Property(e => e.Description).HasColumnName("description");
                entity.Property(e => e.CreatedAt).HasColumnName("created_at");
            });

            // CommitteeMembers
            modelBuilder.Entity<CommitteeMember>(entity =>
            {
                entity.ToTable("committee_members");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.CommitteeId).HasColumnName("committee_id");
                entity.Property(e => e.UserId).HasColumnName("user_id");
                entity.Property(e => e.RoleInCommittee).HasColumnName("role_in_committee");
                entity.Property(e => e.AddedAt).HasColumnName("added_at");
            });

            // Departments
            modelBuilder.Entity<Department>(entity =>
            {
                entity.ToTable("departments");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.Name).HasColumnName("name");
                entity.Property(e => e.Description).HasColumnName("description");
                entity.Property(e => e.CreatedAt).HasColumnName("created_at");
            });

            // DepartmentUsers
            modelBuilder.Entity<DepartmentUser>(entity =>
            {
                entity.ToTable("department_users");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.DepartmentId).HasColumnName("department_id");
                entity.Property(e => e.UserId).HasColumnName("user_id");
                entity.Property(e => e.RoleInDept).HasColumnName("role_in_dept");
            });

            // Meetings
            modelBuilder.Entity<Meeting>(entity =>
            {
                entity.ToTable("meetings");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.CommitteeId).HasColumnName("committee_id");
                entity.Property(e => e.OrganizerId).HasColumnName("organizer_id");
                entity.Property(e => e.Title).HasColumnName("title");
                entity.Property(e => e.StartTime).HasColumnName("start_time");
                entity.Property(e => e.EndTime).HasColumnName("end_time");
                entity.Property(e => e.Location).HasColumnName("location");
                entity.Property(e => e.VirtualLink).HasColumnName("virtual_link");
                entity.Property(e => e.Status).HasColumnName("status");
                entity.Property(e => e.AgendaDeadline).HasColumnName("agenda_deadline");
            });

            // MeetingAttendees
            modelBuilder.Entity<MeetingAttendee>(entity =>
            {
                entity.ToTable("meeting_attendees");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.MeetingId).HasColumnName("meeting_id");
                entity.Property(e => e.UserId).HasColumnName("user_id");
                entity.Property(e => e.Rsvp).HasColumnName("rsvp");
                entity.Property(e => e.RsvpAt).HasColumnName("rsvp_at");
                entity.Property(e => e.Attended).HasColumnName("attended");
                entity.Property(e => e.AttendedAt).HasColumnName("attended_at");
                entity.Property(e => e.RoleInMeeting).HasColumnName("role_in_meeting");
            });

            // AgendaItems
            modelBuilder.Entity<AgendaItem>(entity =>
            {
                entity.ToTable("agenda_items");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.CommitteeId).HasColumnName("committee_id");
                entity.Property(e => e.MeetingId).HasColumnName("meeting_id");
                entity.Property(e => e.ProposerId).HasColumnName("proposer_id");
                entity.Property(e => e.Title).HasColumnName("title");
                entity.Property(e => e.Description).HasColumnName("description");
                entity.Property(e => e.Status).HasColumnName("status");
                entity.Property(e => e.Priority).HasColumnName("priority");
                entity.Property(e => e.EstimatedMinutes).HasColumnName("estimated_minutes");
                entity.Property(e => e.DepartmentId).HasColumnName("department_id");
                entity.Property(e => e.Version).HasColumnName("version");
                entity.Property(e => e.ReviewerNotes).HasColumnName("reviewer_notes");
                entity.Property(e => e.CreatedAt).HasColumnName("created_at");
                entity.Property(e => e.UpdatedAt).HasColumnName("updated_at");
            });

            // AgendaItemVersions
           
            // AgendaWorkflows
            modelBuilder.Entity<AgendaWorkFlow>(entity =>
            {
                entity.ToTable("agenda_workflows");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.AgendaItemId).HasColumnName("agenda_item_id");
                entity.Property(e => e.FromStatus).HasColumnName("from_status");
                entity.Property(e => e.ToStatus).HasColumnName("to_status");
                entity.Property(e => e.ChangedBy).HasColumnName("changed_by");
                entity.Property(e => e.Comment).HasColumnName("comment");
                entity.Property(e => e.ChangedAt).HasColumnName("changed_at");
            });

            // Attachments
            modelBuilder.Entity<Attachment>(entity =>
            {
                entity.ToTable("attachments");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.AgendaItemId).HasColumnName("agenda_item_id");
                entity.Property(e => e.FileName).HasColumnName("filename");
                entity.Property(e => e.FileUrl).HasColumnName("file_url");
                entity.Property(e => e.Checksum).HasColumnName("checksum");
                entity.Property(e => e.Version).HasColumnName("version");
                entity.Property(e => e.IsCurrent).HasColumnName("is_current");
                entity.Property(e => e.UploadedBy).HasColumnName("uploaded_by");
                entity.Property(e => e.ContentType).HasColumnName("content_type");
                entity.Property(e => e.Size).HasColumnName("size");
                entity.Property(e => e.UploadedAt).HasColumnName("uploaded_at");
            });

            // Comments
            modelBuilder.Entity<Comment>(entity =>
            {
                entity.ToTable("comments");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.AgendaItemId).HasColumnName("agenda_item_id");
                entity.Property(e => e.UserId).HasColumnName("user_id");
                entity.Property(e => e.Text).HasColumnName("text");
                entity.Property(e => e.ParentId).HasColumnName("parent_id");
                entity.Property(e => e.CreatedAt).HasColumnName("created_at");
            });

            // Votes
            modelBuilder.Entity<Votes>(entity =>
            {
                entity.ToTable("votes");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.AgendaItemId).HasColumnName("agenda_item_id");
                entity.Property(e => e.UserId).HasColumnName("user_id");
                entity.Property(e => e.VoteValue).HasColumnName("vote_value");
                entity.Property(e => e.VotedAt).HasColumnName("voted_at");
            });

            // ActionItems
            modelBuilder.Entity<ActionItem>(entity =>
            {
                entity.ToTable("action_items");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.MeetingId).HasColumnName("meeting_id");
                entity.Property(e => e.AgendaItemId).HasColumnName("agenda_item_id");
                entity.Property(e => e.Description).HasColumnName("description");
                entity.Property(e => e.AssignedTo).HasColumnName("assigned_to");
                entity.Property(e => e.DueDate).HasColumnName("due_date");
                entity.Property(e => e.Status).HasColumnName("status");
                entity.Property(e => e.CreatedAt).HasColumnName("created_at");
                entity.Property(e => e.ClosedAt).HasColumnName("closed_at");
            });

            // MeetingMinutes
            modelBuilder.Entity<MeetingMinute>(entity =>
            {
                entity.ToTable("meeting_minutes");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.MeetingId).HasColumnName("meetingid");
                entity.Property(e => e.BodyMd).HasColumnName("body_md");
                entity.Property(e => e.ApprovedBy).HasColumnName("approved_by");
                entity.Property(e => e.ApprovedAt).HasColumnName("approved_at");
            });
        }
    }
}
