using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tapal.Data.Repositories.Base
{
    public interface IRepository2<T>    {
        Task<List<T>> GetAll();
        Task<T> GetById(int id);
        void Insert(T entity);
        void InsertRange(ICollection<T> entity);
        void Update(T entity);
        void Delete(T entity);
        Task<int> Commit();
    }
}
