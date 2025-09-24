using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Tapal_models.Models;
using Tapal_Repositories.Context; // Assuming this is where TapalContext is

namespace Tapal_Services
{
    public class AuthService
    {
        private readonly IConfiguration _config;
        private readonly TapalContext _context;

        public AuthService(IConfiguration config, TapalContext context)
        {
            _config = config;
            _context = context;
        }

        public async Task<string> GenerateToken(User user, bool refreshToken = false) // Defaulting refreshToken to false
        {
            var secretKey = _config["JwtSettings:SecretKey"];
            if (string.IsNullOrEmpty(secretKey) || secretKey.Length < 32)
            {
                throw new ArgumentException("JWT SecretKey is not configured correctly or is too short. It must be at least 32 bytes long.");
            }

            var keyBytes = Encoding.UTF8.GetBytes(secretKey);
            var securityKey = new SymmetricSecurityKey(keyBytes);
            var creds = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            DateTime tokenExpiry = refreshToken
                ? DateTime.UtcNow.AddDays(_config.GetValue<int>("JwtSettings:RefreshTokenExpiryInDays"))
                : DateTime.UtcNow.AddMinutes(_config.GetValue<int>("JwtSettings:TokenExpiryInMinutes"));

            var claims = new List<Claim>
            {
                new(JwtRegisteredClaimNames.Sub, user.Email ?? string.Empty), // Subject (usually user identifier)
                new(ClaimTypes.Name, user.Name ?? user.Email ?? string.Empty), // Display name

                new("id", user.Id.ToString()), 
            };

            var roles = await _context.UserRoles
                .Include(ur => ur.Role) // Ensure Role is loaded if you need Role.Name
                .Where(ur => ur.UserId == user.Id)
                .Select(ur => ur.Role.Name) // Select the role name
                .ToListAsync();

            foreach (var role in roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role)); // Add each role as a ClaimType.Role
            }

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = tokenExpiry,
                Issuer = _config["JwtSettings:Issuer"],
                Audience = _config["JwtSettings:Audience"],
                SigningCredentials = creds
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }
    }
}