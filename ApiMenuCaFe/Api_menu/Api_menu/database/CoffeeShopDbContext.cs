using Api_menu.model;
using Microsoft.EntityFrameworkCore;

namespace Api_menu.database
{
    public class CoffeeShopDbContext : DbContext
    {
        public CoffeeShopDbContext(DbContextOptions<CoffeeShopDbContext> options)
            : base(options) { }

        public DbSet<User> Users { get; set; }
        public DbSet<Drink> Drinks { get; set; }
        public DbSet<Favorite> Favorites { get; set; }

        // Cấu hình các thuộc tính khi tạo bảng
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Đảm bảo cột Price có kiểu decimal(18, 2)
            modelBuilder.Entity<Drink>()
                .Property(d => d.Price)
                .HasPrecision(18, 2);  // Đặt kiểu dữ liệu chính xác
        }
    }
}
