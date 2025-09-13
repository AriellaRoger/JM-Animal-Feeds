-- JM Animal Feeds ERP System Database Schema
-- Database: feedsjm
-- Version: 1.0
-- Created: 2025

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+03:00";

-- --------------------------------------------------------
-- Database Creation
-- --------------------------------------------------------

CREATE DATABASE IF NOT EXISTS `feedsjm` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `feedsjm`;

-- --------------------------------------------------------
-- Table structure for table `branches`
-- --------------------------------------------------------

CREATE TABLE `branches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `branch_name` varchar(100) NOT NULL,
  `branch_code` varchar(20) NOT NULL UNIQUE,
  `location` varchar(255) NOT NULL,
  `address` text,
  `phone` varchar(20),
  `email` varchar(100),
  `is_hq` tinyint(1) DEFAULT 0,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_branch_code` (`branch_code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `users`
-- --------------------------------------------------------

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL UNIQUE,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `role` enum('Administrator','Branch Operator','Supervisor','Production Operator','Transport Officer') NOT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_branch_user` (`branch_id`),
  CONSTRAINT `fk_user_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `activity_logs`
-- --------------------------------------------------------

CREATE TABLE `activity_logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `action` varchar(100) NOT NULL,
  `module` varchar(50) NOT NULL,
  `description` text,
  `ip_address` varchar(45),
  `user_agent` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_activity` (`user_id`),
  KEY `idx_activity_date` (`created_at`),
  KEY `idx_module` (`module`),
  CONSTRAINT `fk_activity_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `inventory_categories`
-- --------------------------------------------------------

CREATE TABLE `inventory_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `category_type` enum('Raw Material','Packaging Material','Finished Product','Third Party Product') NOT NULL,
  `description` text,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_category_type` (`category_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `inventory_items`
-- --------------------------------------------------------

CREATE TABLE `inventory_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_code` varchar(50) NOT NULL UNIQUE,
  `item_name` varchar(255) NOT NULL,
  `category_id` int(11) NOT NULL,
  `unit_of_measurement` enum('KG','Litres','Pieces','Bags','Bottles','Packets','Sado','Debe','Gunia') NOT NULL,
  `conversion_factor` decimal(10,4) DEFAULT 1.0000 COMMENT 'For Pumba conversions',
  `min_stock_level` decimal(15,3) DEFAULT 0,
  `max_stock_level` decimal(15,3) DEFAULT NULL,
  `reorder_level` decimal(15,3) DEFAULT 0,
  `cost_price` decimal(15,2) DEFAULT 0,
  `wholesale_price` decimal(15,2) DEFAULT 0,
  `retail_price` decimal(15,2) DEFAULT 0,
  `description` text,
  `barcode` varchar(100),
  `status` enum('active','inactive','discontinued') DEFAULT 'active',
  `created_by` int(11),
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_item_code` (`item_code`),
  KEY `idx_category_item` (`category_id`),
  KEY `idx_status_item` (`status`),
  CONSTRAINT `fk_item_category` FOREIGN KEY (`category_id`) REFERENCES `inventory_categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `inventory_stock`
-- --------------------------------------------------------

CREATE TABLE `inventory_stock` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `quantity` decimal(15,3) NOT NULL DEFAULT 0,
  `reserved_quantity` decimal(15,3) DEFAULT 0,
  `available_quantity` decimal(15,3) GENERATED ALWAYS AS (`quantity` - `reserved_quantity`) STORED,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_item_branch` (`item_id`, `branch_id`),
  KEY `idx_stock_item` (`item_id`),
  KEY `idx_stock_branch` (`branch_id`),
  CONSTRAINT `fk_stock_item` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`),
  CONSTRAINT `fk_stock_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `formulas`
-- --------------------------------------------------------

CREATE TABLE `formulas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `formula_code` varchar(50) NOT NULL UNIQUE,
  `formula_name` varchar(255) NOT NULL,
  `version` varchar(20) DEFAULT '1.0',
  `total_input_kg` decimal(15,3) NOT NULL,
  `expected_output_kg` decimal(15,3) NOT NULL,
  `description` text,
  `notes` text,
  `status` enum('active','inactive','archived') DEFAULT 'active',
  `created_by` int(11),
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_formula_code` (`formula_code`),
  KEY `idx_formula_status` (`status`),
  CONSTRAINT `fk_formula_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `formula_ingredients`
-- --------------------------------------------------------

CREATE TABLE `formula_ingredients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `formula_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `unit_of_measurement` varchar(20) NOT NULL,
  `cost_per_unit` decimal(15,2),
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `idx_formula_ingredient` (`formula_id`),
  KEY `idx_ingredient_item` (`item_id`),
  CONSTRAINT `fk_ingredient_formula` FOREIGN KEY (`formula_id`) REFERENCES `formulas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ingredient_item` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `production_batches`
-- --------------------------------------------------------

CREATE TABLE `production_batches` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `batch_number` varchar(50) NOT NULL UNIQUE,
  `formula_id` int(11) NOT NULL,
  `operator_id` int(11) NOT NULL,
  `supervisor_id` int(11) DEFAULT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime DEFAULT NULL,
  `status` enum('started','paused','completed','cancelled') DEFAULT 'started',
  `pause_reason` text,
  `total_input_kg` decimal(15,3),
  `total_output_kg` decimal(15,3),
  `production_cost` decimal(15,2),
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_batch_number` (`batch_number`),
  KEY `idx_production_formula` (`formula_id`),
  KEY `idx_production_operator` (`operator_id`),
  KEY `idx_production_status` (`status`),
  KEY `idx_production_date` (`start_time`),
  CONSTRAINT `fk_production_formula` FOREIGN KEY (`formula_id`) REFERENCES `formulas` (`id`),
  CONSTRAINT `fk_production_operator` FOREIGN KEY (`operator_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `production_outputs`
-- --------------------------------------------------------

CREATE TABLE `production_outputs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `batch_id` bigint(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `package_size` enum('50KG','25KG','20KG','10KG','5KG') NOT NULL,
  `quantity_bags` int(11) NOT NULL,
  `total_kg` decimal(15,3) NOT NULL,
  `cost_per_bag` decimal(15,2),
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_output_batch` (`batch_id`),
  KEY `idx_output_product` (`product_id`),
  CONSTRAINT `fk_output_batch` FOREIGN KEY (`batch_id`) REFERENCES `production_batches` (`id`),
  CONSTRAINT `fk_output_product` FOREIGN KEY (`product_id`) REFERENCES `inventory_items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `product_serials`
-- --------------------------------------------------------

CREATE TABLE `product_serials` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `serial_number` varchar(100) NOT NULL UNIQUE,
  `batch_id` bigint(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `package_size` enum('50KG','25KG','20KG','10KG','5KG') NOT NULL,
  `qr_code` text,
  `barcode` varchar(100),
  `production_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `status` enum('in_stock','opened','sold','damaged','expired') DEFAULT 'in_stock',
  `current_branch_id` int(11) DEFAULT NULL,
  `opened_date` datetime DEFAULT NULL,
  `opened_by` int(11) DEFAULT NULL,
  `remaining_kg` decimal(10,3) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_serial` (`serial_number`),
  KEY `idx_serial_batch` (`batch_id`),
  KEY `idx_serial_product` (`product_id`),
  KEY `idx_serial_status` (`status`),
  KEY `idx_serial_branch` (`current_branch_id`),
  CONSTRAINT `fk_serial_batch` FOREIGN KEY (`batch_id`) REFERENCES `production_batches` (`id`),
  CONSTRAINT `fk_serial_product` FOREIGN KEY (`product_id`) REFERENCES `inventory_items` (`id`),
  CONSTRAINT `fk_serial_branch` FOREIGN KEY (`current_branch_id`) REFERENCES `branches` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `suppliers`
-- --------------------------------------------------------

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_code` varchar(50) NOT NULL UNIQUE,
  `supplier_name` varchar(255) NOT NULL,
  `contact_person` varchar(100),
  `phone` varchar(20) NOT NULL,
  `email` varchar(100),
  `address` text,
  `tin_number` varchar(50),
  `payment_terms` enum('Cash','7 Days','15 Days','30 Days','45 Days','60 Days') DEFAULT '30 Days',
  `credit_limit` decimal(15,2) DEFAULT 0,
  `current_balance` decimal(15,2) DEFAULT 0,
  `status` enum('active','inactive','blocked') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_supplier_code` (`supplier_code`),
  KEY `idx_supplier_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `purchases`
-- --------------------------------------------------------

CREATE TABLE `purchases` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `purchase_number` varchar(50) NOT NULL UNIQUE,
  `supplier_id` int(11) NOT NULL,
  `purchase_date` date NOT NULL,
  `delivery_date` date DEFAULT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `paid_amount` decimal(15,2) DEFAULT 0,
  `balance_amount` decimal(15,2) GENERATED ALWAYS AS (`total_amount` - `paid_amount`) STORED,
  `payment_status` enum('pending','partial','paid') DEFAULT 'pending',
  `status` enum('draft','ordered','received','cancelled') DEFAULT 'draft',
  `notes` text,
  `created_by` int(11),
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_purchase_number` (`purchase_number`),
  KEY `idx_purchase_supplier` (`supplier_id`),
  KEY `idx_purchase_date` (`purchase_date`),
  KEY `idx_purchase_status` (`status`),
  CONSTRAINT `fk_purchase_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  CONSTRAINT `fk_purchase_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `purchase_items`
-- --------------------------------------------------------

CREATE TABLE `purchase_items` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `purchase_id` bigint(20) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `total_price` decimal(15,2) GENERATED ALWAYS AS (`quantity` * `unit_price`) STORED,
  `received_quantity` decimal(15,3) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_purchase_item` (`purchase_id`),
  KEY `idx_item_purchase` (`item_id`),
  CONSTRAINT `fk_purchase_item_purchase` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_purchase_item_item` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `customers`
-- --------------------------------------------------------

CREATE TABLE `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_code` varchar(50) NOT NULL UNIQUE,
  `customer_name` varchar(255) NOT NULL,
  `customer_type` enum('individual','business') DEFAULT 'individual',
  `phone` varchar(20) NOT NULL,
  `email` varchar(100),
  `address` text,
  `tin_number` varchar(50),
  `credit_limit` decimal(15,2) DEFAULT 0,
  `current_balance` decimal(15,2) DEFAULT 0,
  `loyalty_points` int(11) DEFAULT 0,
  `branch_id` int(11) DEFAULT NULL,
  `status` enum('active','inactive','blocked') DEFAULT 'active',
  `created_by` int(11),
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_customer_code` (`customer_code`),
  KEY `idx_customer_phone` (`phone`),
  KEY `idx_customer_branch` (`branch_id`),
  KEY `idx_customer_status` (`status`),
  CONSTRAINT `fk_customer_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_customer_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `orders`
-- --------------------------------------------------------

CREATE TABLE `orders` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_number` varchar(50) NOT NULL UNIQUE,
  `order_type` enum('branch_to_customer','branch_stock_request','direct_delivery') NOT NULL,
  `source_branch_id` int(11) NOT NULL,
  `destination_branch_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `delivery_address` text,
  `transport_officer_id` int(11) DEFAULT NULL,
  `order_date` datetime NOT NULL,
  `delivery_date` datetime DEFAULT NULL,
  `total_amount` decimal(15,2) DEFAULT 0,
  `status` enum('pending','approved','processing','in_transit','delivered','cancelled','rejected') DEFAULT 'pending',
  `approval_by` int(11) DEFAULT NULL,
  `approval_date` datetime DEFAULT NULL,
  `rejection_reason` text,
  `notes` text,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_number` (`order_number`),
  KEY `idx_order_type` (`order_type`),
  KEY `idx_order_source` (`source_branch_id`),
  KEY `idx_order_destination` (`destination_branch_id`),
  KEY `idx_order_customer` (`customer_id`),
  KEY `idx_order_status` (`status`),
  KEY `idx_order_date` (`order_date`),
  CONSTRAINT `fk_order_source` FOREIGN KEY (`source_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_order_destination` FOREIGN KEY (`destination_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_order_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `fk_order_transport` FOREIGN KEY (`transport_officer_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_order_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `order_items`
-- --------------------------------------------------------

CREATE TABLE `order_items` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `total_price` decimal(15,2) GENERATED ALWAYS AS (`quantity` * `unit_price`) STORED,
  `delivered_quantity` decimal(15,3) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_order_item` (`order_id`),
  KEY `idx_item_order` (`item_id`),
  CONSTRAINT `fk_order_item_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_order_item_item` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `sales`
-- --------------------------------------------------------

CREATE TABLE `sales` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sale_number` varchar(50) NOT NULL UNIQUE,
  `branch_id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `sale_date` datetime NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `discount_amount` decimal(15,2) DEFAULT 0,
  `tax_amount` decimal(15,2) DEFAULT 0,
  `total_amount` decimal(15,2) NOT NULL,
  `paid_amount` decimal(15,2) DEFAULT 0,
  `balance_amount` decimal(15,2) GENERATED ALWAYS AS (`total_amount` - `paid_amount`) STORED,
  `payment_method` enum('cash','mobile_money','bank_transfer','credit','mixed') DEFAULT 'cash',
  `payment_reference` varchar(100),
  `payment_status` enum('paid','partial','pending') DEFAULT 'paid',
  `sale_type` enum('cash','credit') DEFAULT 'cash',
  `due_date` date DEFAULT NULL,
  `status` enum('completed','cancelled','refunded') DEFAULT 'completed',
  `cashier_id` int(11) NOT NULL,
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_sale_number` (`sale_number`),
  KEY `idx_sale_branch` (`branch_id`),
  KEY `idx_sale_customer` (`customer_id`),
  KEY `idx_sale_date` (`sale_date`),
  KEY `idx_sale_cashier` (`cashier_id`),
  KEY `idx_payment_status` (`payment_status`),
  CONSTRAINT `fk_sale_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_sale_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `fk_sale_cashier` FOREIGN KEY (`cashier_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `sale_items`
-- --------------------------------------------------------

CREATE TABLE `sale_items` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sale_id` bigint(20) NOT NULL,
  `item_id` int(11) NOT NULL,
  `serial_number` varchar(100) DEFAULT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `discount_amount` decimal(15,2) DEFAULT 0,
  `total_price` decimal(15,2) GENERATED ALWAYS AS ((`quantity` * `unit_price`) - `discount_amount`) STORED,
  `is_from_opened_bag` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_sale_item` (`sale_id`),
  KEY `idx_item_sale` (`item_id`),
  CONSTRAINT `fk_sale_item_sale` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_sale_item_item` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `payment_transactions`
-- --------------------------------------------------------

CREATE TABLE `payment_transactions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `transaction_number` varchar(50) NOT NULL UNIQUE,
  `transaction_type` enum('customer_payment','supplier_payment','expense','refund') NOT NULL,
  `reference_type` enum('sale','purchase','order','expense') NOT NULL,
  `reference_id` bigint(20) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL,
  `payment_method` enum('cash','mobile_money','bank_transfer','cheque') NOT NULL,
  `payment_reference` varchar(100),
  `payment_date` datetime NOT NULL,
  `notes` text,
  `processed_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_transaction_number` (`transaction_number`),
  KEY `idx_transaction_type` (`transaction_type`),
  KEY `idx_payment_date` (`payment_date`),
  KEY `idx_payment_customer` (`customer_id`),
  KEY `idx_payment_supplier` (`supplier_id`),
  CONSTRAINT `fk_payment_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `fk_payment_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  CONSTRAINT `fk_payment_processor` FOREIGN KEY (`processed_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `vehicles`
-- --------------------------------------------------------

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle_number` varchar(50) NOT NULL UNIQUE,
  `vehicle_type` enum('Truck','Van','Motorcycle','Tricycle') NOT NULL,
  `make` varchar(50),
  `model` varchar(50),
  `year` year,
  `registration_number` varchar(50) NOT NULL,
  `primary_driver_id` int(11) DEFAULT NULL,
  `fuel_type` enum('Petrol','Diesel','Electric','Hybrid') DEFAULT 'Petrol',
  `capacity_kg` decimal(10,2),
  `insurance_expiry` date,
  `inspection_expiry` date,
  `status` enum('active','maintenance','inactive','disposed') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_vehicle_number` (`vehicle_number`),
  KEY `idx_vehicle_driver` (`primary_driver_id`),
  KEY `idx_vehicle_status` (`status`),
  CONSTRAINT `fk_vehicle_driver` FOREIGN KEY (`primary_driver_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `fleet_expenses`
-- --------------------------------------------------------

CREATE TABLE `fleet_expenses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `vehicle_id` int(11) NOT NULL,
  `expense_type` enum('Fuel','Maintenance','Service','Repair','Fine','Insurance','License','Other') NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `quantity` decimal(10,3) DEFAULT NULL COMMENT 'For fuel in litres',
  `date` date NOT NULL,
  `odometer_reading` int(11),
  `vendor` varchar(255),
  `reference_number` varchar(100),
  `notes` text,
  `recorded_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_fleet_vehicle` (`vehicle_id`),
  KEY `idx_fleet_type` (`expense_type`),
  KEY `idx_fleet_date` (`date`),
  CONSTRAINT `fk_fleet_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  CONSTRAINT `fk_fleet_recorder` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `expenses`
-- --------------------------------------------------------

CREATE TABLE `expenses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `expense_number` varchar(50) NOT NULL UNIQUE,
  `user_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `expense_type` enum('Fuel','Food Allowance','Transport Allowance','Salary','Wages','Per Diem','Other') NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `reason` text NOT NULL,
  `status` enum('pending','approved','rejected','paid') DEFAULT 'pending',
  `approved_by` int(11) DEFAULT NULL,
  `approval_date` datetime DEFAULT NULL,
  `rejection_reason` text,
  `payment_date` datetime DEFAULT NULL,
  `payment_reference` varchar(100),
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_expense_number` (`expense_number`),
  KEY `idx_expense_user` (`user_id`),
  KEY `idx_expense_branch` (`branch_id`),
  KEY `idx_expense_status` (`status`),
  KEY `idx_expense_date` (`created_at`),
  CONSTRAINT `fk_expense_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_expense_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_expense_approver` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `notifications`
-- --------------------------------------------------------

CREATE TABLE `notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `type` enum('order','expense','approval','stock_alert','payment_reminder','system') NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `reference_type` varchar(50),
  `reference_id` bigint(20),
  `priority` enum('low','medium','high','urgent') DEFAULT 'medium',
  `is_read` tinyint(1) DEFAULT 0,
  `read_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_notification_user` (`user_id`),
  KEY `idx_notification_type` (`type`),
  KEY `idx_notification_read` (`is_read`),
  KEY `idx_notification_date` (`created_at`),
  CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `settings`
-- --------------------------------------------------------

CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL UNIQUE,
  `setting_value` text,
  `setting_type` enum('system','user','branch') DEFAULT 'system',
  `reference_id` int(11) DEFAULT NULL COMMENT 'User ID or Branch ID',
  `description` text,
  `updated_by` int(11),
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_setting_key` (`setting_key`),
  KEY `idx_setting_type` (`setting_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `inventory_transactions`
-- --------------------------------------------------------

CREATE TABLE `inventory_transactions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `transaction_type` enum('purchase','sale','production_input','production_output','transfer','adjustment','return','damage') NOT NULL,
  `item_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `unit_cost` decimal(15,2),
  `reference_type` varchar(50),
  `reference_id` bigint(20),
  `notes` text,
  `processed_by` int(11) NOT NULL,
  `transaction_date` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_transaction_type` (`transaction_type`),
  KEY `idx_transaction_item` (`item_id`),
  KEY `idx_transaction_branch` (`branch_id`),
  KEY `idx_transaction_date` (`transaction_date`),
  CONSTRAINT `fk_inv_trans_item` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`),
  CONSTRAINT `fk_inv_trans_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_inv_trans_user` FOREIGN KEY (`processed_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `opened_bags`
-- --------------------------------------------------------

CREATE TABLE `opened_bags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serial_number` varchar(100) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `original_kg` decimal(10,3) NOT NULL,
  `remaining_kg` decimal(10,3) NOT NULL,
  `opened_date` datetime NOT NULL,
  `opened_by` int(11) NOT NULL,
  `status` enum('active','finished') DEFAULT 'active',
  `finished_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_opened_bag` (`serial_number`, `branch_id`),
  KEY `idx_opened_branch` (`branch_id`),
  KEY `idx_opened_product` (`product_id`),
  KEY `idx_opened_status` (`status`),
  CONSTRAINT `fk_opened_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_opened_product` FOREIGN KEY (`product_id`) REFERENCES `inventory_items` (`id`),
  CONSTRAINT `fk_opened_user` FOREIGN KEY (`opened_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `stock_transfers`
-- --------------------------------------------------------

CREATE TABLE `stock_transfers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `transfer_number` varchar(50) NOT NULL UNIQUE,
  `from_branch_id` int(11) NOT NULL,
  `to_branch_id` int(11) NOT NULL,
  `transfer_date` datetime NOT NULL,
  `status` enum('pending','in_transit','completed','cancelled') DEFAULT 'pending',
  `notes` text,
  `created_by` int(11) NOT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `received_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_transfer_number` (`transfer_number`),
  KEY `idx_transfer_from` (`from_branch_id`),
  KEY `idx_transfer_to` (`to_branch_id`),
  KEY `idx_transfer_status` (`status`),
  CONSTRAINT `fk_transfer_from` FOREIGN KEY (`from_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_transfer_to` FOREIGN KEY (`to_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_transfer_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `stock_transfer_items`
-- --------------------------------------------------------

CREATE TABLE `stock_transfer_items` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `transfer_id` bigint(20) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `received_quantity` decimal(15,3) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_transfer_item` (`transfer_id`),
  KEY `idx_item_transfer` (`item_id`),
  CONSTRAINT `fk_transfer_item_transfer` FOREIGN KEY (`transfer_id`) REFERENCES `stock_transfers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_transfer_item_item` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `pumba_conversions`
-- --------------------------------------------------------

CREATE TABLE `pumba_conversions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_unit` enum('Sado','Debe','Gunia','KG') NOT NULL,
  `to_unit` enum('Sado','Debe','Gunia','KG') NOT NULL,
  `conversion_factor` decimal(10,4) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_conversion` (`from_unit`, `to_unit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `loyalty_programs`
-- --------------------------------------------------------

CREATE TABLE `loyalty_programs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `program_name` varchar(255) NOT NULL,
  `points_per_amount` decimal(10,2) NOT NULL COMMENT 'Points earned per currency unit',
  `redemption_value` decimal(10,2) NOT NULL COMMENT 'Currency value per point',
  `min_redemption_points` int(11) DEFAULT 100,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `loyalty_transactions`
-- --------------------------------------------------------

CREATE TABLE `loyalty_transactions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) NOT NULL,
  `transaction_type` enum('earned','redeemed','expired','adjusted') NOT NULL,
  `points` int(11) NOT NULL,
  `reference_type` varchar(50),
  `reference_id` bigint(20),
  `balance_after` int(11) NOT NULL,
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_loyalty_customer` (`customer_id`),
  KEY `idx_loyalty_type` (`transaction_type`),
  CONSTRAINT `fk_loyalty_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `promotions`
-- --------------------------------------------------------

CREATE TABLE `promotions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `promotion_code` varchar(50) NOT NULL UNIQUE,
  `promotion_name` varchar(255) NOT NULL,
  `promotion_type` enum('percentage','fixed_amount','buy_x_get_y','bundle') NOT NULL,
  `value` decimal(15,2) NOT NULL,
  `min_purchase_amount` decimal(15,2) DEFAULT 0,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `applicable_items` text COMMENT 'JSON array of item IDs',
  `applicable_branches` text COMMENT 'JSON array of branch IDs',
  `usage_limit` int(11) DEFAULT NULL,
  `used_count` int(11) DEFAULT 0,
  `status` enum('active','inactive','expired') DEFAULT 'active',
  `created_by` int(11),
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_promotion_code` (`promotion_code`),
  KEY `idx_promotion_dates` (`start_date`, `end_date`),
  KEY `idx_promotion_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Insert default data
-- --------------------------------------------------------

-- Insert branches
INSERT INTO `branches` (`branch_name`, `branch_code`, `location`, `address`, `phone`, `email`, `is_hq`) VALUES
('Headquarters', 'HQ001', 'Dar Es Salaam', 'Mbezi Beach, Dar Es Salaam', '+255 123 456 789', 'hq@jmfeeds.co.tz', 1),
('Kigoma Branch', 'BR002', 'Kigoma', 'Kigoma Town Center', '+255 123 456 790', 'kigoma@jmfeeds.co.tz', 0),
('Mwanza Branch', 'BR003', 'Mwanza', 'Mwanza City', '+255 123 456 791', 'mwanza@jmfeeds.co.tz', 0),
('Arusha Branch', 'BR004', 'Arusha', 'Arusha Town', '+255 123 456 792', 'arusha@jmfeeds.co.tz', 0),
('Dodoma Branch', 'BR005', 'Dodoma', 'Dodoma City', '+255 123 456 793', 'dodoma@jmfeeds.co.tz', 0),
('Mbeya Branch', 'BR006', 'Mbeya', 'Mbeya Town', '+255 123 456 794', 'mbeya@jmfeeds.co.tz', 0);

-- Insert sample users
INSERT INTO `users` (`first_name`, `last_name`, `email`, `password`, `phone`, `role`, `branch_id`) VALUES
-- Administrators
('John', 'Mwamba', 'john.admin@jmfeeds.co.tz', '$2y$10$YourHashedPasswordHere', '+255 700 000 001', 'Administrator', 1),
('Sarah', 'Kimaro', 'sarah.admin@jmfeeds.co.tz', '$2y$10$YourHashedPasswordHere', '+255 700 000 002', 'Administrator', 1),

-- Branch Operators
('James', 'Mushi', 'james.kigoma@jmfeeds.co.tz', '$2y$10$YourHashedPasswordHere', '+255 700 000 003', 'Branch Operator', 2),
('Mary', 'Lyimo', 'mary.mwanza@jmfeeds.co.tz', '$2y$10$YourHashedPasswordHere', '+255 700 000 004', 'Branch Operator', 3),
('Peter', 'Swai', 'peter.arusha@jmfeeds.co.tz', '$2y$10$YourHashedPasswordHere', '+255 700 000 005', 'Branch Operator', 4),
('Grace', 'Mwita', 'grace.dodoma@jmfeeds.co.tz', '$2y$10$YourHashedPasswordHere', '+255 700 000 006', 'Branch Operator', 5),

-- Supervisors
('Robert', 'Kaaya', 'robert.supervisor@jmfeeds.co.tz', '$2y$10$YourHashedPasswordHere', '+255 700 000 007', 'Supervisor', 1),
('Diana', 'Mchome', 'diana.supervisor@jmfeeds.co.tz', '$2y$10$YourHashedPasswordHere', '+255 700 000 008', 'Supervisor', 1),

-- Production Operators
('Michael', 'Ngowi', 'michael.production@jmfeeds.co.tz', '$2y$10$YourHashedPasswordHere', '+255 700 000 009', 'Production Operator', 1),
('Alice', 'Temba', 'alice.production@jmfeeds.co.tz', '$2y$10$YourHashedPasswordHere', '+255 700 000 010', 'Production Operator', 1),

-- Transport Officers
('David', 'Mollel', 'david.transport@jmfeeds.co.tz', '$2y$10$YourHashedPasswordHere', '+255 700 000 011', 'Transport Officer', 1),
('Joseph', 'Tarimo', 'joseph.transport@jmfeeds.co.tz', '$2y$10$YourHashedPasswordHere', '+255 700 000 012', 'Transport Officer', 1);

-- Insert Pumba conversions
INSERT INTO `pumba_conversions` (`from_unit`, `to_unit`, `conversion_factor`) VALUES
('Sado', 'Debe', 0.2500),  -- 4 Sados = 1 Debe
('Debe', 'Sado', 4.0000),
('Debe', 'Gunia', 0.1667), -- 6 Debes = 1 Gunia
('Gunia', 'Debe', 6.0000),
('Sado', 'Gunia', 0.0417), -- 24 Sados = 1 Gunia
('Gunia', 'Sado', 24.0000),
('Gunia', 'KG', 100.0000), -- 1 Gunia = 100 KG
('KG', 'Gunia', 0.0100),
('Debe', 'KG', 16.6667),   -- 1 Debe = 16.67 KG
('KG', 'Debe', 0.0600),
('Sado', 'KG', 4.1667),     -- 1 Sado = 4.17 KG
('KG', 'Sado', 0.2400);

-- Insert inventory categories
INSERT INTO `inventory_categories` (`category_name`, `category_type`, `description`) VALUES
('Grains', 'Raw Material', 'Grain-based raw materials'),
('Proteins', 'Raw Material', 'Protein-based raw materials'),
('Minerals', 'Raw Material', 'Mineral supplements'),
('Vitamins', 'Raw Material', 'Vitamin supplements'),
('Oils', 'Raw Material', 'Oil-based raw materials'),
('Bags', 'Packaging Material', 'Packaging bags of various sizes'),
('Chicken Feed', 'Finished Product', 'Feed products for chickens'),
('Cattle Feed', 'Finished Product', 'Feed products for cattle'),
('Pig Feed', 'Finished Product', 'Feed products for pigs'),
('Veterinary Medicine', 'Third Party Product', 'Veterinary medicines and supplements');

-- Insert default settings
INSERT INTO `settings` (`setting_key`, `setting_value`, `setting_type`, `description`) VALUES
('company_name', 'JM Animal Feeds', 'system', 'Company name'),
('company_tin', '123-456-789', 'system', 'Tax Identification Number'),
('currency', 'TZS', 'system', 'Default currency'),
('tax_rate', '18', 'system', 'Default VAT rate percentage'),
('fiscal_year_start', '01-01', 'system', 'Fiscal year start month-day'),
('backup_frequency', 'daily', 'system', 'Backup frequency'),
('session_timeout', '30', 'system', 'Session timeout in minutes'),
('date_format', 'Y-m-d', 'system', 'System date format'),
('time_format', 'H:i:s', 'system', 'System time format'),
('decimal_places', '2', 'system', 'Decimal places for amounts');

-- Create indexes for better performance
CREATE INDEX idx_activity_user_date ON activity_logs(user_id, created_at);
CREATE INDEX idx_inventory_trans_ref ON inventory_transactions(reference_type, reference_id);
CREATE INDEX idx_payment_trans_ref ON payment_transactions(reference_type, reference_id);
CREATE INDEX idx_notification_user_unread ON notifications(user_id, is_read);
CREATE INDEX idx_sale_payment_date ON sales(payment_status, sale_date);
CREATE INDEX idx_purchase_payment_date ON purchases(payment_status, purchase_date);

-- --------------------------------------------------------
-- End of schema
-- --------------------------------------------------------