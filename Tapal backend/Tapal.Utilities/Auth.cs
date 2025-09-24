using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Web.Http.Results;
using Tapal_models.Models;

namespace Tapal.Utilities
{
    public class Auth : AuthorizeAttribute, IAuthorizationFilter
    {
        public string Permissions { get; set; } = string.Empty;

        public void OnAuthorization(AuthorizationFilterContext context)
        {
            var claimsPrincipal = context.HttpContext.User;



            // 🔹 Extract user info from JWT claims
            var user = new User
            {
                Id = Guid.Parse(claimsPrincipal.Claims.FirstOrDefault(c => c.Type == "id")?.Value ?? Guid.Empty.ToString()),
                Email = claimsPrincipal.Claims.FirstOrDefault(c => c.Type == ClaimTypes.Name || c.Type == JwtRegisteredClaimNames.Sub)?.Value ?? string.Empty,
                Name = claimsPrincipal.Identity?.Name ?? string.Empty
            };

            // 🔹 Get roles from claims (multiple possible)
            var roles = claimsPrincipal.Claims
                .Where(c => c.Type == ClaimTypes.Role)
                .Select(c => c.Value)
                .ToList();

            // 🔹 Store user + roles in HttpContext for later use
            context.HttpContext.Items["User"] = user;
            context.HttpContext.Items["Roles"] = roles;

            // 🔹 Permission check (if required)
            if (!string.IsNullOrWhiteSpace(Permissions))
            {
                var requiredPermissions = Permissions.Split(",", StringSplitOptions.RemoveEmptyEntries);
                if (!roles.Any(r => requiredPermissions.Contains(r)))
                {
                    context.Result = new ForbidResult();
                    return;
                }
            }
        }
    }
}
