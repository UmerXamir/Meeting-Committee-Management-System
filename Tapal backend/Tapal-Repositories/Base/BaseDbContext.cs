using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Tapal.Data.Repositories.Base;

namespace Guardian.ORM.Data.Repositories.Base
{
    public class BaseDbContext<T> : DbContext, IDbContext where T : DbContext
    {

        public BaseDbContext() { }
        public BaseDbContext(DbContextOptions<T> options) : base(options)
        {

        }

        public BaseDbContext(DbContextOptions<T> options, IConfigureOptions<T> configuration) : base(options)
        {

        }



        public DbContext GetDbContext()
        {
            return this;
        }

        public override int SaveChanges()
        {
            return base.SaveChanges();
        }

        public async Task<int> Commit()
        {
            return await base.SaveChangesAsync();
        }
    }
}

