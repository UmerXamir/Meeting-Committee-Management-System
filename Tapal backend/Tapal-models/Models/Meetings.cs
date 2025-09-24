using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tapal_models.Models
{
    public class Meeting
    {
        public Guid Id { get; set; }
        public Guid CommitteeId { get; set; }
        public Committee Committee { get; set; } = null!;

        public Guid OrganizerId { get; set; }
        public User Organizer { get; set; } = null!;

        public string Title { get; set; } = null!;
        public DateTime StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public string? Location { get; set; }
        public string? VirtualLink { get; set; }
        public string Status { get; set; } = "draft";
        public DateTime? AgendaDeadline { get; set; }
        public DateTime? created_at { get; set; }

        public ICollection<AgendaItem> AgendaItems { get; set; } = new List<AgendaItem>();
        public ICollection<MeetingAttendee> Attendees { get; set; } = new List<MeetingAttendee>();
    }

    public class MeetingAttendee
    {
        public Guid Id { get; set; }
        public Guid MeetingId { get; set; }
        public Meeting Meeting { get; set; } = null!;

        public Guid UserId { get; set; }
        public User User { get; set; } = null!;

        public string Rsvp { get; set; } = "pending";
        public DateTime? RsvpAt { get; set; }
        public bool Attended { get; set; }
        public DateTime? AttendedAt { get; set; }
        public string? RoleInMeeting { get; set; }
    }
}
