
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Tapal.Data.Models.Base;

namespace Tapal.Data.Repositories.Base
{
    public class BaseRepository<TEntity, TContext> : IRepository<TEntity>
       where TEntity : BaseEntity

       where TContext : DbContext, IDbContext
    {
        protected readonly TContext dbContext;
        protected readonly DbSet<TEntity> dbSet;

        public BaseRepository(TContext dbContext)
        {
            this.dbContext = dbContext;
            this.dbSet = dbContext.Set<TEntity>();
        }

        public virtual async Task<List<TEntity>> GetAll()
        {
            return await dbSet.ToListAsync();
        }

        public virtual async Task<int> Count()
        {
            return await dbSet.CountAsync();
        }

        public virtual async Task<TEntity> GetById(int id)
        {
            try
            {
                return await dbSet.FindAsync(id);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return null!;
            }
        }

        public virtual void Insert(TEntity entity)
        {
            dbSet.Add(entity);
        }

        public virtual void Update(TEntity entity)
        {
            dbSet.Update(entity);
        }

        public virtual void Delete(TEntity entity)
        {
            dbSet.Remove(entity);
        }

        public virtual void DeleteRange(List<TEntity> entities)
        {
            dbSet.RemoveRange(entities);
        }
        public async virtual Task<int> Commit()
        {
            return await dbContext.Commit();
        }
    }
}
