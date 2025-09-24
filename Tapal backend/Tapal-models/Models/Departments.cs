using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tapal_models.Models
{
    public class Department
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = null!;
        public string? Description { get; set; }
        public DateTime CreatedAt { get; set; }

        public ICollection<DepartmentUser> DepartmentUsers { get; set; } = new List<DepartmentUser>();
    }

    public class DepartmentUser
    {
        public Guid Id { get; set; }
        public Guid DepartmentId { get; set; }
        public Department Department { get; set; } = null!;

        public Guid UserId { get; set; }
        public User User { get; set; } = null!;

        public string RoleInDept { get; set; } = "coordinator";
    }
}
