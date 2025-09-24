using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tapal_models.Models
{
    public class AgendaWorkFlow
    {
        public Guid Id { get; set; }
        public Guid AgendaItemId { get; set; }
        public AgendaItem AgendaItem { get; set; } = null!;

        public string? FromStatus { get; set; }
        public string ToStatus { get; set; } = null!;
        public Guid? ChangedBy { get; set; }
        public User? ChangedByUser { get; set; }

        public string? Comment { get; set; }
        public DateTime ChangedAt { get; set; }
    }
}
