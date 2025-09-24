using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tapal.Data.Models.Base
{
    public interface IEntity
    {
        public int Created_By_ID { get; set; }
        public string Created_By_Name { get; set; }
        public DateTime Created_Date { get; set; }
        public int? Updated_By_ID { get; set; }
        public string? Updated_By_Name { get; set; }
        public DateTime? Updated_Date { get; set; }
    }
}
