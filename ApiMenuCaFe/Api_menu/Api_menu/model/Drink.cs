using System.ComponentModel.DataAnnotations.Schema;

namespace Api_menu.model
{
    public class Drink
    {
        public int DrinkID { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }

        [Column(TypeName = "decimal(18, 2)")]
        public decimal Price { get; set; }
        public string ImageURL { get; set; }
    }
}
