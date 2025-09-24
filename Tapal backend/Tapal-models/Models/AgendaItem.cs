using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace Tapal_models.Models
{
    public class AgendaItem
    {
        public Guid Id { get; set; }
        public Guid CommitteeId { get; set; }
        public Committee Committee { get; set; } = null!;

        public Guid? MeetingId { get; set; }
        public Meeting? Meeting { get; set; }

        public Guid ProposerId { get; set; }
        public User Proposer { get; set; } = null!;

        public string Title { get; set; } = null!;
        public string? Description { get; set; }
        public string Status { get; set; } = "draft"; // draft | in_review | finalized
        public string? Priority { get; set; } // low | medium | high
        public int? EstimatedMinutes { get; set; }
        public Guid? DepartmentId { get; set; }
        public Department? Department { get; set; }

        public int Version { get; set; } = 1;
        public string? ReviewerNotes { get; set; }

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        // Relationships
        //public ICollection<AgendaItemVersion> Versions { get; set; } = new List<AgendaItemVersion>();
        public ICollection<AgendaWorkFlow> Workflows { get; set; } = new List<AgendaWorkFlow>();
        public ICollection<Attachment> Attachments { get; set; } = new List<Attachment>();
        public ICollection<Comment> Comments { get; set; } = new List<Comment>();
        public ICollection<Votes> Votes { get; set; } = new List<Votes>();
    }
}
