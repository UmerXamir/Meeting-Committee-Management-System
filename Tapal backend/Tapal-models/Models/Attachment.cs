using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tapal_models.Models
{

    public class Attachment
    {
        public Guid Id { get; set; }
        public Guid? AgendaItemId { get; set; }
        public AgendaItem? AgendaItem { get; set; }

        public string FileName { get; set; } = null!;
        public string FileUrl { get; set; } = null!;
        public string? Checksum { get; set; }
        public int Version { get; set; } = 1;
        public bool IsCurrent { get; set; } = true;

        public Guid? UploadedBy { get; set; }
        //public Guid? UserId { get; set; }

        //public User? Uploader { get; set; }
        public string? ContentType { get; set; }
        public long? Size { get; set; }

        public DateTime UploadedAt { get; set; }
    }
}
