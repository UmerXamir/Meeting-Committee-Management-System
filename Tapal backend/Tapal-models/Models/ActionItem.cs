using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tapal_models.Models
{
    public class ActionItem
    {
        public Guid Id { get; set; }
        public Guid? MeetingId { get; set; }
        public Meeting? Meeting { get; set; }

        public Guid? AgendaItemId { get; set; }
        public AgendaItem? AgendaItem { get; set; }

        public string Description { get; set; } = null!;
        public Guid? AssignedTo { get; set; }
        public User? AssignedUser { get; set; }

        public DateTime? DueDate { get; set; }
        public string Status { get; set; } = "open"; // open | in_progress | completed
        public DateTime CreatedAt { get; set; }
        public DateTime? ClosedAt { get; set; }
    }
}
