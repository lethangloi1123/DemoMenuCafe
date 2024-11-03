using Api_menu.database;
using Api_menu.model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.IO;

namespace Api_menu.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DrinksController : ControllerBase
    {
        private readonly CoffeeShopDbContext _context;
        public DrinksController(CoffeeShopDbContext context)
        {
            _context = context;
        }

        // API: Lấy danh sách tất cả thức uống
        [HttpGet]
        public async Task<IActionResult> GetDrinks()
        {
            var drinks = await _context.Drinks.ToListAsync();
            return Ok(drinks);
        }

        // API: Thêm thức uống mới (với upload ảnh)
        [HttpPost("upload-drink")]
        public async Task<IActionResult> UploadDrink(
            [FromForm] IFormFile image,
            [FromForm] string name,
            [FromForm] string description,
            [FromForm] decimal price)
        {
            if (image == null || image.Length == 0)
                return BadRequest("Vui lòng chọn ảnh hợp lệ.");

            // Tạo thư mục lưu ảnh nếu chưa tồn tại
            var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images");
            if (!Directory.Exists(uploadsFolder))
                Directory.CreateDirectory(uploadsFolder);

            // Đặt tên file ngẫu nhiên để tránh trùng lặp
            var fileName = Guid.NewGuid().ToString() + Path.GetExtension(image.FileName);
            var filePath = Path.Combine(uploadsFolder, fileName);

            // Lưu ảnh vào thư mục
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await image.CopyToAsync(stream);
            }

            // Tạo URL ảnh
            var imageUrl = $"{Request.Scheme}://{Request.Host}/images/{fileName}";

            // Thêm thức uống mới vào cơ sở dữ liệu
            var drink = new Drink
            {
                Name = name,
                Description = description,
                Price = price,
                ImageURL = imageUrl
            };

            _context.Drinks.Add(drink);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetDrinkById), new { id = drink.DrinkID }, drink);
        }

        // API: Lấy thông tin thức uống theo ID
        [HttpGet("{id}")]
        public async Task<IActionResult> GetDrinkById(int id)
        {
            var drink = await _context.Drinks.FindAsync(id);
            if (drink == null) return NotFound();
            return Ok(drink);
        }

        // API: Cập nhật thông tin thức uống
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateDrink(int id, [FromBody] Drink drink)
        {
            if (id != drink.DrinkID) return BadRequest();
            _context.Entry(drink).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return NoContent();
        }

        // API: Xóa thức uống
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteDrink(int id)
        {
            var drink = await _context.Drinks.FindAsync(id);
            if (drink == null) return NotFound();
            _context.Drinks.Remove(drink);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
