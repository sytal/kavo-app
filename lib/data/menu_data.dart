import 'menu_item.dart';

const List<String> menuCategories = ['Loaded Fries', 'Burgers', 'Shakes & Drinks', 'Desserts'];

const List<MenuItem> menuItems = [
  // Loaded Fries
  MenuItem(
    name: 'The Crunches Loaded',
    category: 'Loaded Fries',
    description: 'Crispy fries buried under melted cheese, beef crumble, and house sauce.',
    price: 'Rs. 650',
    image: 'lobster-roll.jpg',
    tags: ['Fan Favorite', 'Extra Cheese', 'Shareable'],
  ),
  MenuItem(
    name: 'Peri Peri Fries',
    category: 'Loaded Fries',
    description: 'Hand-cut fries tossed in fiery peri peri spice, finished with garlic mayo.',
    price: 'Rs. 450',
    image: 'tuscan-grilled.jpg',
    tags: ['Spicy', 'Hand-Cut', 'Crowd Favorite'],
  ),
  MenuItem(
    name: 'Smoky BBQ Fries',
    category: 'Loaded Fries',
    description: 'Loaded with smoky BBQ pulled beef, cheddar drizzle, and crispy onions.',
    price: 'Rs. 700',
    image: 'caesar.jpg',
    tags: ['Smoky', 'BBQ', 'Loaded'],
  ),
  MenuItem(
    name: 'Classic Salted Fries',
    category: 'Loaded Fries',
    description: 'Golden, crispy, and simple — the fries that started it all.',
    price: 'Rs. 350',
    image: 'bread-barrel.jpg',
    tags: ['Classic', 'Crispy', 'Quick Bite'],
  ),

  // Burgers
  MenuItem(
    name: 'Crunches Signature Stack',
    category: 'Burgers',
    description: 'Double beef patty, melted cheese, caramelized onions, house special sauce.',
    price: 'Rs. 950',
    image: 'about.jpg',
    tags: ["Chef's Pick", 'Double Patty', 'Signature'],
  ),
  MenuItem(
    name: 'Smoky BBQ Burger',
    category: 'Burgers',
    description: 'Beef patty glazed in smoky BBQ sauce, crispy onion rings, smoked cheddar.',
    price: 'Rs. 850',
    image: 'mozzarella.jpg',
    tags: ['BBQ', 'Smoked Cheddar', 'Onion Rings'],
  ),
  MenuItem(
    name: 'Zinger Crunch Burger',
    category: 'Burgers',
    description: 'Crispy fried chicken fillet, spicy mayo, fresh lettuce, toasted bun.',
    price: 'Rs. 800',
    image: 'greek-salad.jpg',
    tags: ['Crispy Chicken', 'Spicy Mayo', 'Best Seller'],
  ),
  MenuItem(
    name: 'Cheese Melt Burger',
    category: 'Burgers',
    description: 'Single patty drenched in a triple-cheese blend — simple, messy, worth it.',
    price: 'Rs. 700',
    image: 'spinach-salad.jpg',
    tags: ['Triple Cheese', 'Classic', 'Gooey'],
  ),

  // Shakes & Drinks
  MenuItem(
    name: 'Nutella Overload Shake',
    category: 'Shakes & Drinks',
    description: 'Thick Nutella shake, whipped cream, chocolate drizzle, crushed wafers.',
    price: 'Rs. 550',
    image: 'cake.jpg',
    tags: ['Nutella', 'Thick Shake', 'Indulgent'],
  ),
  MenuItem(
    name: 'Oreo Blast',
    category: 'Shakes & Drinks',
    description: 'Crushed Oreos blended into a creamy vanilla base, topped with cookie crumbs.',
    price: 'Rs. 500',
    image: 'spinach-salad.jpg',
    tags: ['Oreo', 'Creamy', 'Crowd Favorite'],
  ),
  MenuItem(
    name: 'Classic Lemonade',
    category: 'Shakes & Drinks',
    description: 'Fresh-squeezed lemonade, mint, and a hint of soda for the fizz.',
    price: 'Rs. 350',
    image: 'lobster-bisque.jpg',
    tags: ['Fresh', 'Minty', 'Refreshing'],
  ),
  MenuItem(
    name: 'Iced Mocha Freeze',
    category: 'Shakes & Drinks',
    description: 'Blended cold coffee, chocolate syrup, and a cloud of whipped cream.',
    price: 'Rs. 480',
    image: 'fire-from-wok.jpg',
    tags: ['Cold Coffee', 'Chocolate', 'Blended'],
  ),

  // Desserts
  MenuItem(
    name: 'Molten Chocolate Brownie',
    category: 'Desserts',
    description: 'Warm chocolate brownie, molten center, vanilla ice cream, chocolate drizzle.',
    price: 'Rs. 480',
    image: 'cake.jpg',
    tags: ["Crunches' Classic", 'Molten Center', 'Warm'],
  ),
  MenuItem(
    name: 'Nutella Waffle',
    category: 'Desserts',
    description: 'Crisp waffle loaded with Nutella, banana slices, and powdered sugar.',
    price: 'Rs. 550',
    image: 'spinach-salad.jpg',
    tags: ['Nutella', 'Crisp', 'Shareable'],
  ),
  MenuItem(
    name: 'Churros & Dip',
    category: 'Desserts',
    description: 'Crispy cinnamon-sugar churros served with warm chocolate dip.',
    price: 'Rs. 450',
    image: 'lobster-bisque.jpg',
    tags: ['Crispy', 'Cinnamon Sugar', 'Dippable'],
  ),
];
