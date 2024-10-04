
-- Viewing each of the four initial tables
SELECT *
	FROM pizza_general

SELECT *
	FROM pizza_types

SELECT *
	FROM order_general

SELECT *
	FROM order_details

-- Initializing combined 'combined_pizza_data' table 
CREATE TABLE combined_pizza_data (
	order_id FLOAT,
	item_id FLOAT,
	order_date DATETIME,
	order_time DATETIME,
	pizza_category NVARCHAR(255),
	pizza_name NVARCHAR(255),
	pizza_type NVARCHAR(255),
	pizza_size NVARCHAR(255),
	quantity FLOAT,
	total_price FLOAT
)

-- Joining initial tables upon shared id values, and extracting relevant data columns to place in 'combined_pizza_data' table
INSERT INTO combined_pizza_data (order_id, item_id, order_date, order_time, pizza_category, pizza_name, pizza_type, pizza_size, quantity, total_price)
	SELECT 
		od.order_id, 
		od.order_details_id,
		og.date,
		og.time,
		pt.category,
		pt.name,
		pt.pizza_type_id,
		pg.size,
		od.quantity,
		pg.price * od.quantity
	FROM order_details od
	JOIN order_general og
		ON od.order_id = og.order_id
	JOIN pizza_general pg
		ON od.pizza_id = pg.pizza_id
	JOIN pizza_types pt
		ON pg.pizza_type_id = pt.pizza_type_id

-- Viewing entire combined 'combined_pizza_data' table
SELECT *
	FROM combined_pizza_data

-- Combining separate order date and time columns into 'combined_time' column
UPDATE combined_pizza_data
	SET order_date = CAST(order_date AS DATE)

UPDATE combined_pizza_data
	SET order_time = CAST(order_time AS TIME)

ALTER TABLE combined_pizza_data
	ADD combined_time DATETIME

UPDATE combined_pizza_data
	SET combined_time = order_date + order_time

-- Removing the separate order date and time columns, now that a combined one exists
ALTER TABLE combined_pizza_data
	DROP COLUMN order_date, order_time

-- Changing abbreviations for pizza sizes to entire words
UPDATE combined_pizza_data
	SET pizza_size = 'Small'
	WHERE pizza_size = 'S'

UPDATE combined_pizza_data
	SET pizza_size = 'Medium'
	WHERE pizza_size = 'M'

UPDATE combined_pizza_data
	SET pizza_size = 'Large'
	WHERE pizza_size = 'L'

UPDATE combined_pizza_data
	SET pizza_size = 'Extra Large'
	WHERE pizza_size = 'XL'

UPDATE combined_pizza_data
	SET pizza_size = 'Extra Extra Large'
	WHERE pizza_size = 'XXL'

-- Standardizing price format for visual purposes
ALTER TABLE combined_pizza_data
	ALTER COLUMN total_price DECIMAL(5, 2)
