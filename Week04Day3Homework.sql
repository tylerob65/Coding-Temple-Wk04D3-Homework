-- Week 4 Day 4 Homework

-- 1. List all customers who live in Texas (use JOINs)

-- 1. Join method
SELECT first_name,last_name
FROM customer
INNER JOIN address
ON address.address_id = customer.address_id
WHERE district = 'Texas';

-- 1. Subquery method
SELECT first_name,last_name
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE district = 'Texas'
);

-- 2. Get all payments above $6.99 with the Customer's Full Name

-- 2. Join method
SELECT customer.first_name,customer.last_name,payment.amount
FROM customer
INNER JOIN payment
ON payment.customer_id = customer.customer_id
WHERE payment.amount > 6.99;


-- 2. Subquery method
SELECT *
FROM (
    SELECT customer.first_name,customer.last_name,payment.amount
    FROM customer
    INNER JOIN payment
    ON payment.customer_id = customer.customer_id
    WHERE payment.amount > 6.99
) AS i_technically_used_a_subquery;

-- 3. Show all customers names who have made payments over $175 (use subqueries)

-- 3. Join method
SELECT DISTINCT customer.first_name, customer.last_name, amount
FROM customer
JOIN payment
ON payment.customer_id = customer.customer_id
WHERE payment.amount > 175;

-- 3. subquery method
SELECT first_name,last_name
FROM customer
WHERE customer_id in (
    SELECT customer_id
    FROM payment
    WHERE amount > 175
);

-- 4. List all customers that live in Nepal (use the city table)

-- 4. Join method
SELECT customer.first_name, customer.last_name
FROM customer
JOIN address
ON address.address_id = customer.address_id
JOIN city
ON city.city_id = address.city_id
JOIN country
ON country.country_id = city.country_id
WHERE country.country = 'Nepal';

-- 4. Subquery method
SELECT first_name, last_name
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id IN (
            SELECT country_id
            FROM country
            WHERE country = 'Nepal'
        )
    )
);

-- 5. Which staff member had the most transactions?

-- 5. subquery method
SELECT first_name, last_name
FROM staff
WHERE staff_id IN (
    SELECT staff_id
    FROM payment
    GROUP BY staff_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 5. Join method
SELECT staff.first_name, staff.last_name
FROM payment
JOIN staff
ON staff.staff_id = payment.staff_id
GROUP BY staff.first_name, staff.last_name
ORDER BY count(*) DESC
LIMIT 1;

-- 6. How many movies of each rating are there?
SELECT rating,count(*)
FROM film
GROUP BY rating;

-- It felt too impractical to use a join or a subquery to solve question above
-- So I'm making a new one that I can solve with a join and with a subquery...
-- 6.5 How many action movies of each rating are there?

-- 6.5 subquery method
SELECT rating, COUNT(*)
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_category
    WHERE category_id IN (
        SELECT category_id
        FROM category
        WHERE name = 'Action'
    )
)
GROUP BY rating;

-- 6.5 Join method
SELECT film.rating, COUNT(*)
FROM category
JOIN film_category
ON film_category.category_id = category.category_id
JOIN film
ON film.film_id = film_category.film_id
WHERE category.name = 'Action'
GROUP BY film.rating;

-- 7.Show all customers who have made a single payment above $6.99 (Use Subqueries)

-- 7. subquery method
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM payment
    WHERE amount > 6.99
    GROUP BY customer_id
    HAVING COUNT(*) = 1
);

-- 7. Join method
SELECT customer.first_name,customer.last_name
FROM payment
JOIN customer
ON customer.customer_id = payment.customer_id
WHERE payment.amount > 6.99
GROUP BY customer.customer_id
HAVING COUNT(8) = 1;

-- 8. How many free rentals did our stores give away?
-- I am chosing to ignore all the negative payment amounts someone accidentally put in table

-- 8. subquery method
SELECT COUNT(*)
FROM rental
WHERE return_date IS NOT NULL AND rental_id NOT IN (
    SELECT DISTINCT rental_id
    FROM payment
);

-- 8. Join method
SELECT count(*)
FROM rental
LEFT JOIN payment
ON payment.rental_id = rental.rental_id
WHERE payment.rental_id IS NULL;