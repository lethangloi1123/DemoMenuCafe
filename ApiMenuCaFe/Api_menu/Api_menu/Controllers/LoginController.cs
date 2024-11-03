using Api_menu.database;
using Api_menu.model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly CoffeeShopDbContext _context;

    public AuthController(CoffeeShopDbContext context)
    {
        _context = context;
    }

    // Đăng ký
    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] User user)
    {
        // Kiểm tra email hoặc số điện thoại đã tồn tại
        if (await _context.Users.AnyAsync(u => u.Email == user.Email))
            return BadRequest("Email đã được sử dụng.");

        if (await _context.Users.AnyAsync(u => u.PhoneNumber == user.PhoneNumber))
            return BadRequest("Số điện thoại đã được sử dụng.");

        // Lưu người dùng vào CSDL
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return Ok("Đăng ký thành công!");
    }

    // Đăng nhập
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        var user = await _context.Users.FirstOrDefaultAsync(u =>
            u.Email == request.EmailOrPhone || u.PhoneNumber == request.EmailOrPhone);

        // Kiểm tra người dùng và mật khẩu
        if (user == null || user.Password != request.Password)
            return Unauthorized(new { message = "Email/Số điện thoại hoặc mật khẩu không đúng." });

        return Ok(new { message = "Đăng nhập thành công!", role = user.Role });
    }
}

// Lớp để nhận dữ liệu đăng nhập từ Body JSON
public class LoginRequest
{
    public string EmailOrPhone { get; set; }
    public string Password { get; set; }
}
