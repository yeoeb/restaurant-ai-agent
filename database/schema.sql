-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2024-06-12 07:04:54
-- 伺服器版本： 10.4.32-MariaDB
-- PHP 版本： 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `cbb109110`
--

-- --------------------------------------------------------

--
-- 資料表結構 `menu_items`
--

CREATE TABLE `menu_items` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `menu_items`
--

INSERT INTO `menu_items` (`id`, `name`, `description`, `price`) VALUES
(3, 'Pasta', 'Creamy Alfredo pasta', 8.99),
(4, 'Salad', 'Fresh garden salad', 5.99),
(17, 'Pizza', 'Delicious cheese pizza', 10.00),
(18, 'Burger', 'Juicy beef burger', 8.50),
(19, 'Salad', 'Fresh garden salad', 10.00),
(21, 'Pizza', 'Delicious cheese pizza', 10.00),
(22, 'Burger', 'Juicy beef burger', 7.99),
(23, 'Pasta', 'Creamy Alfredo pasta', 8.99),
(24, 'Salad', 'Fresh garden salad', 5.99),
(25, 'Sushi', 'Fresh salmon sushi', 12.00),
(26, 'Steak', 'Grilled ribeye steak', 25.00),
(27, 'Sandwich', 'Turkey and cheese sandwich', 6.50),
(28, 'Soup', 'Tomato basil soup', 4.50),
(29, 'Fries', 'Crispy French fries', 3.50),
(30, 'Ice Cream', 'Vanilla ice cream', 3.00),
(31, 'Tacos', 'Spicy chicken tacos', 7.00),
(32, 'Burrito', 'Beef burrito with cheese', 8.50),
(33, 'Pizza', 'Pepperoni pizza', 11.00),
(34, 'Burger', 'Veggie burger', 6.99),
(35, 'Pasta', 'Spaghetti Bolognese', 9.50),
(36, 'Salad', 'Caesar salad', 6.99),
(37, 'Sushi', 'Tuna sushi', 13.00),
(38, 'Steak', 'Filet mignon', 30.00),
(39, 'Sandwich', 'BLT sandwich', 5.50),
(40, 'Soup', 'Chicken noodle soup', 4.99),
(41, 'Fries', 'Sweet potato fries', 4.00),
(42, 'Ice Cream', 'Chocolate ice cream', 3.50),
(43, 'Tacos', 'Fish tacos', 7.50),
(44, 'Burrito', 'Vegetarian burrito', 7.99),
(45, 'Pizza', 'Hawaiian pizza', 12.00),
(46, 'Burger', 'Bacon cheeseburger', 8.99),
(47, 'Pasta', 'Pesto pasta', 8.50),
(48, 'Salad', 'Greek salad', 6.50),
(49, 'Sushi', 'Eel sushi', 14.00),
(50, 'Steak', 'T-bone steak', 28.00);

-- --------------------------------------------------------

--
-- 資料表結構 `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `order_date` date NOT NULL,
  `order_time` time NOT NULL,
  `order_number` int(11) NOT NULL,
  `status` enum('current','historical') NOT NULL DEFAULT 'current'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `total_price`, `order_date`, `order_time`, `order_number`, `status`) VALUES
(1, 1, 15.50, '2024-06-05', '12:30:00', 1, 'current'),
(2, 2, 25.00, '2024-06-05', '13:00:00', 2, 'current'),
(3, 1, 35.75, '2024-06-06', '14:00:00', 1, 'current'),
(4, 3, 45.00, '2024-06-06', '14:30:00', 2, ''),
(5, 1, 29.00, '2024-06-06', '07:50:37', 3, 'current'),
(6, 1, 12.00, '2024-06-06', '07:53:36', 4, 'current'),
(7, 1, 29.00, '2024-06-06', '07:55:38', 5, 'current'),
(8, 10, 20.00, '2024-06-06', '08:00:58', 6, 'current'),
(9, 10, 15.00, '2024-06-06', '14:02:39', 7, ''),
(10, 10, 28.00, '2024-06-06', '16:09:33', 8, ''),
(11, 10, 40.00, '2024-06-06', '16:10:09', 9, ''),
(12, 10, 12.00, '2024-06-06', '17:36:54', 10, ''),
(13, 10, 30.00, '2024-06-06', '17:59:27', 11, ''),
(14, 10, 30.00, '2024-06-06', '18:07:16', 12, ''),
(15, 10, 30.00, '2024-06-06', '18:11:48', 13, ''),
(16, 10, 15.00, '2024-06-06', '20:57:36', 14, ''),
(17, 7, 10.00, '2024-06-07', '12:38:08', 1, ''),
(18, 7, 40.00, '2024-06-07', '12:49:52', 2, ''),
(19, 7, 60.00, '2024-06-07', '12:51:45', 3, ''),
(20, 7, 15.00, '2024-06-07', '13:38:45', 4, ''),
(21, 10, 93.00, '2024-06-10', '19:15:13', 1, 'current'),
(22, 10, 66.00, '2024-06-11', '10:32:50', 1, 'current'),
(23, 10, 0.00, '2024-06-11', '10:34:45', 2, ''),
(24, 10, 36.00, '2024-06-11', '10:36:42', 3, 'current'),
(25, 10, 106.00, '2024-06-11', '12:47:20', 4, 'current'),
(26, 10, 96.00, '2024-06-11', '12:47:43', 5, 'current'),
(27, 10, 117.00, '2024-06-11', '12:49:19', 6, 'current'),
(28, 10, 81.00, '2024-06-11', '12:49:47', 7, 'current'),
(29, 10, 119.48, '2024-06-11', '13:14:49', 8, 'current'),
(30, 10, 139.48, '2024-06-11', '13:16:51', 9, 'current'),
(31, 10, 139.48, '2024-06-11', '13:17:52', 10, 'current'),
(32, 10, 139.48, '2024-06-11', '13:39:14', 11, ''),
(33, 10, 139.48, '2024-06-11', '13:39:43', 12, 'current'),
(34, 10, 149.48, '2024-06-11', '13:49:31', 13, 'current'),
(35, 10, 149.48, '2024-06-11', '13:49:41', 14, 'current'),
(36, 10, 149.48, '2024-06-11', '13:49:47', 15, 'current'),
(37, 10, 149.48, '2024-06-11', '13:50:03', 16, 'current'),
(38, 10, 149.48, '2024-06-11', '13:53:52', 17, 'current'),
(39, 10, 20.00, '2024-06-11', '20:41:26', 18, 'current'),
(40, 10, 28.50, '2024-06-11', '23:07:59', 19, 'current'),
(41, 10, 46.49, '2024-06-12', '10:24:40', 1, ''),
(42, 74, 15.99, '2024-06-12', '11:02:18', 2, 'current'),
(43, 10, 59.93, '2024-06-12', '12:09:58', 3, 'current'),
(44, 10, 104.00, '2024-06-12', '12:57:52', 4, 'current'),
(45, 74, 35.97, '2024-06-12', '12:59:28', 5, 'current');

-- --------------------------------------------------------

--
-- 資料表結構 `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `menu_item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `menu_item_id`, `quantity`, `price`) VALUES
(1, 1, 1, 1, 15.50),
(2, 2, 2, 2, 12.50),
(3, 3, 3, 3, 11.92),
(4, 4, 4, 4, 11.25),
(5, 5, 1, 2, 10.00),
(6, 5, 3, 1, 8.99),
(7, 6, 4, 2, 5.99),
(8, 7, 1, 2, 10.00),
(9, 7, 3, 1, 8.99),
(10, 8, 1, 2, 10.00),
(11, 9, 4, 1, 5.99),
(12, 9, 3, 1, 8.99),
(13, 10, 4, 3, 5.99),
(14, 10, 11, 1, 10.00),
(15, 11, 1, 3, 10.00),
(16, 11, 11, 1, 10.00),
(17, 12, 4, 2, 5.99),
(18, 13, 1, 3, 10.00),
(19, 14, 1, 3, 10.00),
(20, 15, 1, 3, 10.00),
(21, 16, 19, 1, 5.00),
(22, 16, 11, 1, 10.00),
(23, 17, 19, 2, 5.00),
(24, 18, 1, 2, 20.00),
(25, 19, 1, 3, 20.00),
(26, 20, 19, 3, 5.00),
(27, 21, 19, 5, 10.00),
(28, 21, 18, 5, 8.50),
(29, 22, 47, 3, 8.50),
(30, 22, 29, 3, 3.50),
(31, 22, 21, 3, 10.00),
(32, 24, 19, 3, 10.00),
(33, 24, 30, 2, 3.00),
(34, 25, 19, 3, 10.00),
(35, 25, 21, 6, 10.00),
(36, 25, 22, 2, 7.99),
(37, 26, 21, 8, 10.00),
(38, 26, 22, 2, 7.99),
(39, 27, 21, 6, 10.00),
(40, 27, 22, 2, 7.99),
(41, 27, 39, 2, 5.50),
(42, 27, 38, 1, 30.00),
(43, 28, 21, 6, 10.00),
(44, 28, 22, 2, 7.99),
(45, 28, 39, 1, 5.50),
(46, 29, 21, 7, 10.00),
(47, 29, 22, 2, 7.99),
(48, 29, 39, 1, 5.50),
(49, 29, 50, 1, 28.00),
(50, 30, 21, 9, 10.00),
(51, 30, 22, 2, 7.99),
(52, 30, 39, 1, 5.50),
(53, 30, 50, 1, 28.00),
(54, 31, 21, 9, 10.00),
(55, 31, 22, 2, 7.99),
(56, 31, 39, 1, 5.50),
(57, 31, 50, 1, 28.00),
(58, 32, 21, 9, 10.00),
(59, 32, 22, 2, 7.99),
(60, 32, 39, 1, 5.50),
(61, 32, 50, 1, 28.00),
(62, 33, 21, 9, 10.00),
(63, 33, 22, 2, 7.99),
(64, 33, 39, 1, 5.50),
(65, 33, 50, 1, 28.00),
(66, 34, 21, 10, 10.00),
(67, 34, 22, 2, 7.99),
(68, 34, 39, 1, 5.50),
(69, 34, 50, 1, 28.00),
(70, 35, 21, 10, 10.00),
(71, 35, 22, 2, 7.99),
(72, 35, 39, 1, 5.50),
(73, 35, 50, 1, 28.00),
(74, 36, 21, 10, 10.00),
(75, 36, 22, 2, 7.99),
(76, 36, 39, 1, 5.50),
(77, 36, 50, 1, 28.00),
(78, 37, 21, 10, 10.00),
(79, 37, 22, 2, 7.99),
(80, 37, 39, 1, 5.50),
(81, 37, 50, 1, 28.00),
(82, 38, 21, 10, 10.00),
(83, 38, 22, 2, 7.99),
(84, 38, 39, 1, 5.50),
(85, 38, 50, 1, 28.00),
(86, 39, 21, 1, 10.00),
(87, 39, 1, 1, 10.00),
(88, 40, 1, 1, 10.00),
(89, 40, 19, 1, 10.00),
(90, 40, 18, 1, 8.50),
(91, 41, 1, 1, 10.00),
(92, 41, 19, 1, 10.00),
(93, 41, 18, 1, 8.50),
(94, 41, 17, 1, 10.00),
(95, 41, 2, 1, 7.99),
(96, 42, 24, 1, 5.99),
(97, 42, 21, 1, 10.00),
(98, 43, 23, 6, 8.99),
(99, 43, 24, 1, 5.99),
(100, 44, 32, 4, 8.50),
(101, 44, 50, 2, 28.00),
(102, 44, 49, 1, 14.00),
(103, 45, 23, 2, 8.99),
(104, 45, 24, 1, 5.99),
(105, 45, 41, 3, 4.00);

-- --------------------------------------------------------

--
-- 資料表結構 `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `account` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `type` enum('admin','editor','customer') NOT NULL,
  `phone` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `users`
--

INSERT INTO `users` (`id`, `name`, `account`, `password`, `type`, `phone`) VALUES
(3, 'Customer One', 'cust1', 'password_hash', 'customer', ''),
(6, 'admin1', 'admin', '1', 'admin', ''),
(7, '12', '2', '1', 'editor', '0'),
(10, '12', '12', '$2y$10$k0K2A1z0EZ0fKvrF14Qp1u8wSVQ26tmfQlb0XQj56dIxDYxEyvsGq', 'editor', ''),
(11, 'admin1', 'admin1@example.com', '$2y$10$PCJl9ygj.emGoL2WmKqn9OyU529Xs2UxibZyqo7IxVPKeLmPu2su.', 'admin', ''),
(14, 'User1', 'user1', 'password_hash1', 'customer', '1234567890'),
(15, 'User2', 'user2', 'password_hash2', 'customer', '1234567891'),
(16, 'User3', 'user3', 'password_hash3', 'customer', '1234567892'),
(17, 'User4', 'user4', 'password_hash4', 'customer', '1234567893'),
(18, 'User5', 'user5', 'password_hash5', 'customer', '1234567894'),
(19, 'User6', 'user6', 'password_hash6', 'customer', '1234567895'),
(20, 'User7', 'user7', 'password_hash7', 'customer', '1234567896'),
(21, 'User8', 'user8', 'password_hash8', 'customer', '1234567897'),
(22, 'User9', 'user9', 'password_hash9', 'customer', '1234567898'),
(23, 'User10', 'user10', 'password_hash10', 'customer', '1234567899'),
(24, 'User11', 'user11', 'password_hash11', 'customer', '1234567800'),
(25, 'User12', 'user12', 'password_hash12', 'customer', '1234567801'),
(26, 'User13', 'user13', 'password_hash13', 'customer', '1234567802'),
(27, 'User14', 'user14', 'password_hash14', 'customer', '1234567803'),
(28, 'User15', 'user15', 'password_hash15', 'customer', '1234567804'),
(29, 'User16', 'user16', 'password_hash16', 'customer', '1234567805'),
(30, 'User17', 'user17', 'password_hash17', 'customer', '1234567806'),
(31, 'User18', 'user18', 'password_hash18', 'customer', '1234567807'),
(32, 'User19', 'user19', 'password_hash19', 'customer', '1234567808'),
(33, 'User20', 'user20', 'password_hash20', 'customer', '1234567809'),
(34, 'User21', 'user21', 'password_hash21', 'customer', '1234567810'),
(35, 'User22', 'user22', 'password_hash22', 'customer', '1234567811'),
(36, 'User23', 'user23', 'password_hash23', 'customer', '1234567812'),
(37, 'User24', 'user24', 'password_hash24', 'customer', '1234567813'),
(38, 'User25', 'user25', 'password_hash25', 'customer', '1234567814'),
(39, 'User26', 'user26', 'password_hash26', 'customer', '1234567815'),
(40, 'User27', 'user27', 'password_hash27', 'customer', '1234567816'),
(41, 'User28', 'user28', 'password_hash28', 'customer', '1234567817'),
(42, 'User29', 'user29', 'password_hash29', 'customer', '1234567818'),
(43, 'User30', 'user30', 'password_hash30', 'customer', '1234567819'),
(74, '21', '21', '$2y$10$0HI7xD9wk3Aefl0evT5Mg.uTSq8XfAUFcAzQjVEdNFG8OaxsCgpxO', 'customer', '');

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`id`);

--
-- 資料表索引 `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- 資料表索引 `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`);

--
-- 資料表索引 `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `account` (`account`);

--
-- 在傾印的資料表使用自動遞增(AUTO_INCREMENT)
--

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
