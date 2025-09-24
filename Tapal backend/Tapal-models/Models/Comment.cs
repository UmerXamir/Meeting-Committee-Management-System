using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tapal_models.Models
{
    public class Comment
    {
        public Guid Id { get; set; }
        public Guid AgendaItemId { get; set; }
        public AgendaItem AgendaItem { get; set; } = null!;

        public Guid UserId { get; set; }
        public User User { get; set; } = null!;

        public string Text { get; set; } = null!;
        public Guid? ParentId { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
