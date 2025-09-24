using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;

namespace Tapal.Data.Models.Base
{
    public class BaseEntity : IEntity
    {
        public int Created_By_ID { get; set; }
        public string Created_By_Name { get; set; } = string.Empty;
        public DateTime Created_Date { get; set; } = DateTime.UtcNow;
        public int? Updated_By_ID { get; set; }
        public string? Updated_By_Name { get; set; } = string.Empty;
        public DateTime? Updated_Date { get; set; }
    }
}
