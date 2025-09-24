using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tapal_models.Models
{
    public class MeetingMinute
    {
        public Guid Id { get; set; }
        public Guid? MeetingId { get; set; }
        public Meeting? Meeting { get; set; }

        public string? BodyMd { get; set; }
        public Guid? ApprovedBy { get; set; }
        public User? Approver { get; set; }
        public DateTime? ApprovedAt { get; set; }
    }
}
