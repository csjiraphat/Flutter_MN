-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 14, 2024 at 07:12 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mn_641463003`
--

-- --------------------------------------------------------

--
-- Table structure for table `place`
--

CREATE TABLE `place` (
  `place_code` varchar(5) NOT NULL,
  `place_name` varchar(100) NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longtitude` decimal(11,8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `place`
--

INSERT INTO `place` (`place_code`, `place_name`, `latitude`, `longtitude`) VALUES
('00001', 'วัดร่องขุ่น', 19.82326700, 99.76013180),
('00003', 'ดอย', 19.23640800, 100.36458500),
('004', 'มหาวิทยาลัยราชภัฏเชียงราย', 19.97945210, 99.84900670),
('2', 'ไม่รู้', 12.36548000, 99.35748000);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `shop_code` varchar(5) NOT NULL,
  `product_code` varchar(5) NOT NULL,
  `product_name` varchar(20) NOT NULL,
  `unit` varchar(15) NOT NULL,
  `price` varchar(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`shop_code`, `product_code`, `product_name`, `unit`, `price`) VALUES
('00001', '54231', 'ขนม', 'ห่อ', '5'),
('00002', '54232', 'น้ำเปล่า', 'แก้ว', '45'),
('00002', '54233', 'rr', '1', '123');

-- --------------------------------------------------------

--
-- Table structure for table `route`
--

CREATE TABLE `route` (
  `no` varchar(5) NOT NULL,
  `place_code` varchar(5) NOT NULL,
  `time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `route`
--

INSERT INTO `route` (`no`, `place_code`, `time`) VALUES
('12345', '00001', '12:00:00'),
('12347', '004', '15:30:00'),
('12348', '00003', '08:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `shop`
--

CREATE TABLE `shop` (
  `shop_code` varchar(5) NOT NULL,
  `shop_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shop`
--

INSERT INTO `shop` (`shop_code`, `shop_name`) VALUES
('00001', 'ร้านหนมจีน'),
('00002', 'น้ำปั่น');

-- --------------------------------------------------------

--
-- Table structure for table `tram`
--

CREATE TABLE `tram` (
  `code` varchar(3) NOT NULL,
  `tram_code` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tram`
--

INSERT INTO `tram` (`code`, `tram_code`) VALUES
('001', '12345'),
('2', '005'),
('3', '123');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(5) NOT NULL,
  `firstname` varchar(30) NOT NULL,
  `lastname` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL,
  `password` varchar(20) NOT NULL,
  `phone` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `firstname`, `lastname`, `email`, `password`, `phone`) VALUES
('00001', 'qqq', 'tyuio', 'admin', '123', '0887531598'),
('00002', 'o', 'w', '1', '12', '0874521');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `place`
--
ALTER TABLE `place`
  ADD PRIMARY KEY (`place_code`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_code`),
  ADD KEY `shop` (`shop_code`);

--
-- Indexes for table `route`
--
ALTER TABLE `route`
  ADD PRIMARY KEY (`no`),
  ADD KEY `place` (`place_code`);

--
-- Indexes for table `shop`
--
ALTER TABLE `shop`
  ADD PRIMARY KEY (`shop_code`);

--
-- Indexes for table `tram`
--
ALTER TABLE `tram`
  ADD PRIMARY KEY (`code`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `shop` FOREIGN KEY (`shop_code`) REFERENCES `shop` (`shop_code`);

--
-- Constraints for table `route`
--
ALTER TABLE `route`
  ADD CONSTRAINT `place` FOREIGN KEY (`place_code`) REFERENCES `place` (`place_code`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
