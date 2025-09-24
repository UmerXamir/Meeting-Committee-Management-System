using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Tapal_Services.HashPassword;
public interface IHashPassword
{
    string Hash(string password);
}