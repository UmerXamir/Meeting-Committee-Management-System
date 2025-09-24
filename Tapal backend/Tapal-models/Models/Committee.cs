using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tapal_models.Models
{
    public class Committee
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = null!;
        public string? Description { get; set; }
        public DateTime CreatedAt { get; set; }

        public ICollection<CommitteeMember> Members { get; set; } = new List<CommitteeMember>();
        public ICollection<Meeting> Meetings { get; set; } = new List<Meeting>();
    }

    public class CommitteeMember
    {
        public Guid Id { get; set; }
        public Guid CommitteeId { get; set; }
        public Committee Committee { get; set; } = null!;

        public Guid UserId { get; set; }
        public User User { get; set; } = null!;

        public string? RoleInCommittee { get; set; }
        public DateTime AddedAt { get; set; }
    }
}
