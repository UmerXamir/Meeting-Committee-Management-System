using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tapal.Data.Repositories.Base
{
    public interface IRepository<T>
    {
        Task<List<T>> GetAll();
        Task<int> Count();
        Task<T> GetById(int id);
        void Insert(T entity);
        void Update(T entity);
        void Delete(T entity);
        void DeleteRange(List<T> entities);
        Task<int> Commit();
    }
}
