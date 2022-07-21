-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.17-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table pmdevandmods.deliverymissionsitems
CREATE TABLE IF NOT EXISTS `deliverymissionsitems` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Buyer` char(255) NOT NULL DEFAULT '0',
  `ShopId` char(255) DEFAULT '0',
  `ShopName` char(255) NOT NULL DEFAULT '0',
  `Coords` longtext NOT NULL DEFAULT '[]',
  `Items` longtext NOT NULL DEFAULT '[]',
  `DriverCut` int(11) NOT NULL,
  `Value` char(255) DEFAULT NULL,
  `active` tinyint(1) DEFAULT 0,
  `Date` date DEFAULT NULL,
  `Time` time DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table pmdevandmods.deliverymissionsitems: ~0 rows (approximately)
DELETE FROM `deliverymissionsitems`;
/*!40000 ALTER TABLE `deliverymissionsitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `deliverymissionsitems` ENABLE KEYS */;

-- Dumping structure for table pmdevandmods.finished_orders
CREATE TABLE IF NOT EXISTS `finished_orders` (
  `ID` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL DEFAULT '0',
  `ShopNumber` varchar(50) NOT NULL DEFAULT '0',
  `Value` varchar(255) NOT NULL DEFAULT '0',
  `Date` date NOT NULL,
  `Time` time NOT NULL,
  `DateFinished` date NOT NULL,
  `TimeFinished` time NOT NULL,
  `Items` varchar(255) NOT NULL DEFAULT '0',
  `DriverCut` int(55) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table pmdevandmods.finished_orders: ~0 rows (approximately)
DELETE FROM `finished_orders`;
/*!40000 ALTER TABLE `finished_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `finished_orders` ENABLE KEYS */;

-- Dumping structure for table pmdevandmods.fuel_stations
CREATE TABLE IF NOT EXISTS `fuel_stations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quantity` float NOT NULL DEFAULT 0,
  `price` float NOT NULL DEFAULT 0,
  `coords` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `ShopNumber` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=533 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table pmdevandmods.fuel_stations: 27 rows
DELETE FROM `fuel_stations`;
/*!40000 ALTER TABLE `fuel_stations` DISABLE KEYS */;
INSERT INTO `fuel_stations` (`id`, `quantity`, `price`, `coords`, `name`, `type`, `ShopNumber`) VALUES
	(1, 5000, 5, '{"y":2778.79,"x":49.42,"z":58.04}', 'Xero GS Desert 1', 'fuel_station', '19'),
	(2, 5000, 5, '{"y":2606.46,"x":263.89,"z":44.98}', 'Globe Oil Harmony 2', 'fuel_station', '20'),
	(3, 5000, 5, '{"y":2671.13,"x":1039.96,"z":39.55}', 'Globe Oil GS Desert 3', 'fuel_station', '21'),
	(4, 5000, 5, '{"y":2660.18,"x":1207.26,"z":37.9}', 'Globe Oil GS Desert 4', 'fuel_station', '22'),
	(5, 5000, 5, '{"y":2594.19,"x":2545.69,"z":37.94}', 'Rex\'s Diner DQ 5', 'fuel_station', '0'),
	(6, 5000, 5, '{"y":3263.95,"x":2679.86,"z":55.24}', 'Earl\'s GS Desert 6', 'fuel_station', '7'),
	(7, 5000, 5, '{"y":3773.89,"x":2005.06,"z":32.4}', 'Sandy\'s Sandy 7', 'fuel_station', '23'),
	(8, 5000, 5, '{"y":4929.39,"x":1687.16,"z":42.08}', 'Ltd Grapeseed 8', 'fuel_station', '15'),
	(9, 5000, 5, '{"y":6416.03,"x":1701.31,"z":32.76}', 'Globe Oil MC 9', 'fuel_station', '13'),
	(10, 5000, 5, '{"y":6622.84,"x":179.86,"z":31.87}', 'Ron Paleto 10', 'fuel_station', '1'),
	(14, 5000, 5, '{"y":-276.75,"x":-1437.62,"z":46.21}', 'Ron MorningWood 14', 'fuel_station', '2'),
	(16, 5000, 5, '{"y":-935.16,"x":-724.62,"z":19.21}', 'Ltd Lil Seoul 16', 'fuel_station', '12'),
	(17, 5000, 5, '{"y":-1211.0,"x":-526.02,"z":18.18}', 'Xero LilS/Calaic Av 17', 'fuel_station', '26'),
	(11, 5000, 5, '{"y":6419.59,"x":-94.46,"z":31.49}', 'Xero Paleto 11', 'fuel_station', '24'),
	(12, 5000, 5, '{"y":2334.4,"x":-2555.0,"z":33.08}', 'Ron Lago Z 12', 'fuel_station', '11'),
	(13, 5000, 5, '{"y":803.66,"x":-1800.38,"z":138.65}', 'Ltd Richman G 13', 'fuel_station', '9'),
	(15, 5000, 5, '{"y":-320.29,"x":-2096.24,"z":13.17}', 'Xero Pacific B 15', 'fuel_station', '25'),
	(19, 5000, 5, '{"y":-1261.31,"x":265.65,"z":29.29}', 'Xero StrawBerry 19', 'fuel_station', '27'),
	(18, 5000, 5, '{"y":-1761.79,"x":-70.21,"z":29.53}', 'Ltd GS 18', 'fuel_station', '8'),
	(20, 5000, 5, '{"y":-1028.85,"x":819.65,"z":26.4}', 'Ron La Mesa 20', 'fuel_station', '28'),
	(21, 5000, 5, '{"y":-1402.57,"x":1208.95,"z":35.22}', 'Ron El Burro 21', 'fuel_station', '29'),
	(22, 5000, 5, '{"y":-330.85,"x":1181.38,"z":69.32}', 'Ltd Mirror Park 22', 'fuel_station', '14'),
	(23, 5000, 5, '{"y":269.1,"x":620.84,"z":103.09}', 'Globe Oil Vinewood 23', 'fuel_station', '30'),
	(24, 5000, 5, '{"y":362.04,"x":2581.32,"z":108.47}', 'Ron MT 24', 'fuel_station', '10'),
	(25, 5000, 5, '{"y":-1562.03,"x":176.63,"z":29.26}', 'Ron Davis 25', 'fuel_station', '18'),
	(27, 5000, 5, '{"y":-1471.71,"x":-319.29,"z":30.55}', 'Globe Oil La Puerta 27', 'fuel_station', '31'),
	(28, 5000, 5, '{"y":3330.55,"x":1784.32,"z":41.25}', 'FlyWheels GS Desert 28', 'fuel_station', '17');
/*!40000 ALTER TABLE `fuel_stations` ENABLE KEYS */;

-- Dumping structure for table pmdevandmods.owned_shops
CREATE TABLE IF NOT EXISTS `owned_shops` (
  `identifier` varchar(250) DEFAULT NULL,
  `ShopNumber` int(11) DEFAULT NULL,
  `money` int(11) DEFAULT 0,
  `ShopValue` int(11) DEFAULT NULL,
  `LastRobbery` int(11) DEFAULT 0,
  `ShopName` varchar(30) DEFAULT NULL,
  `delivery_coords` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table pmdevandmods.owned_shops: ~31 rows (approximately)
DELETE FROM `owned_shops`;
/*!40000 ALTER TABLE `owned_shops` DISABLE KEYS */;
INSERT INTO `owned_shops` (`identifier`, `ShopNumber`, `money`, `ShopValue`, `LastRobbery`, `ShopName`, `delivery_coords`) VALUES
	('0', 1, 0, 280000, 1549000, 'Shop1', '{"x":143.88,"y":6642.57,"z":30.55}'),
	('0', 2, 0, 220000, 1549000, 'Shop2', '{"x":-1425.69,"y":-243.56,"z":45.38}'),
	('0', 3, 0, 235000, 1549000, 'Shop3', '{"x":-343.07,"y":6076.85,"z":30.34}'),
	('0', 4, 0, 285000, 1549000, 'Shop4', '{"x":-667.69,"y":-953.08,"z":20.27}'),
	('0', 5, 0, 135000, 1549000, 'Shop5', '{"x":238.31,"y":-34.84,"z":68.73}'),
	('0', 6, 0, 235000, 1549000, 'Shop6', '{"x":-1322.54,"y":-393.6,"z":36.44}'),
	('0', 7, 0, 160000, 1549000, 'Shop7', '{"x":2660.68,"y":3280.31,"z":54.24}'),
	('0', 8, 0, 275000, 1549000, 'Shop8', '{"x":-34.82,"y":-1749.47,"z":28.17}'),
	('0', 9, 0, 265000, 1549000, 'Shop9', '{"x":-1815.58,"y":790.5,"z":136.91}'),
	('0', 10, 0, 300000, 1549000, 'Shop10', '{"x":2547.18,"y":413.85,"z":107.46}'),
	('0', 11, 0, 225000, 1549000, 'Shop11', '{"x":-2537.68,"y":2346.5,"z":32.06}'),
	('0', 12, 0, 145000, 1549000, 'Shop12', '{"x":-706.84,"y":-920.07,"z":18.01}'),
	('0', 13, 0, 145000, 1549000, 'Shop13', '{"x":1720.62,"y":6425.67,"z":32.38}'),
	('0', 14, 0, 280000, 1549000, 'Shop14', '{"x":1166.67,"y":-327.91,"z":68.07}'),
	('0', 15, 0, 300000, 1549000, 'Shop15', '{"x":1701.82,"y":4912.02,"z":41.08}'),
	('0', 16, 0, 435000, 1549000, 'Shop16', '{"x":142.02,"y":-1269.81,"z":28}'),
	('0', 17, 0, 150000, 1549000, 'Shop17', '{"x":1760.34,"y":3312.15,"z":40.13}'),
	('0', 18, 0, 300000, 1549000, 'Shop18', '{"x":180.85,"y":-1547.02,"z":28.16}'),
	('0', 19, 0, 145000, 1549000, 'Shop19', '{"x":66.14,"y":2785.39,"z":56.88}'),
	('0', 20, 0, 145000, 1549000, 'Shop20', '{"x":261.2,"y":2578,"z":44.08}'),
	('0', 21, 0, 160000, 1549000, 'Shop21', '{"x":1025.94,"y":2655.31,"z":38.55}'),
	('0', 22, 0, 175000, 1549000, 'Shop22', '{"x":1207.06,"y":2641.64,"z":36.82}'),
	('0', 23, 0, 200000, 1549000, 'Shop23', '{"x":1991.12,"y":3760.83,"z":31.18}'),
	('0', 24, 0, 350000, 1549000, 'Shop24', '{"x":-69.81,"y":6427.67,"z":31.44}'),
	('0', 25, 0, 215000, 1549000, 'Shop25', '{"x":-2061.08,"y":-304.9,"z":12.15}'),
	('0', 26, 0, 250000, 1549000, 'Shop26', '{"x":-519.17,"y":-1221.8,"z":17.3}'),
	('0', 27, 0, 350000, 1549000, 'Shop27', '{"x":299.24,"y":-1243.5,"z":29.29}'),
	('0', 28, 0, 235000, 1549000, 'Shop28', '{"x":826.62,"y":-1045.44,"z":26.25}'),
	('0', 29, 0, 195000, 1549000, 'Shop29', '{"x":1198.88,"y":-1382.79,"z":34.23}'),
	('0', 30, 0, 225000, 1549000, 'Shop30', '{"x":647.2,"y":279.88,"z":102.15}'),
	('0', 31, 0, 225000, 1549000, 'Shop31', '{"x":-336.65,"y":-1495.42,"z":29.61}');
/*!40000 ALTER TABLE `owned_shops` ENABLE KEYS */;

-- Dumping structure for table pmdevandmods.owned_shops_storage
CREATE TABLE IF NOT EXISTS `owned_shops_storage` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ShopNumber` char(255) NOT NULL DEFAULT '0',
  `item` char(255) NOT NULL DEFAULT '0',
  `label` char(255) NOT NULL DEFAULT '0',
  `count` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table pmdevandmods.owned_shops_storage: ~2 rows (approximately)
DELETE FROM `owned_shops_storage`;
/*!40000 ALTER TABLE `owned_shops_storage` DISABLE KEYS */;
/*!40000 ALTER TABLE `owned_shops_storage` ENABLE KEYS */;

-- Dumping structure for table pmdevandmods.shops
CREATE TABLE IF NOT EXISTS `shops` (
  `ShopNumber` int(11) NOT NULL DEFAULT 0,
  `src` varchar(50) NOT NULL,
  `count` int(11) NOT NULL,
  `item` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `price` int(11) NOT NULL,
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;

-- Dumping data for table pmdevandmods.shops: ~2 rows (approximately)
DELETE FROM `shops`;
/*!40000 ALTER TABLE `shops` DISABLE KEYS */;
/*!40000 ALTER TABLE `shops` ENABLE KEYS */;
ALTER TABLE `items` ADD `price` FLOAT NOT NULL default '0';
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
