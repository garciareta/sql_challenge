show databases;
use sakila;

-- 1a. Display the first and last names of all actors from the table `actor`.
select first_name, last_name from actor;

--  1b. Display the first and last name of each actor in a single 
--  column in upper case letters. Name the column `Actor Name`.
select concat(first_name, ' ', last_name) as 'Actor Name' from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know 
--  only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name
from actor
where first_name = "JOE";

-- 2b. Find all actors whose last name contain the letters `GEN`:
select first_name, last_name
from actor
where last_name
like('%GEN%');

-- * 2c. Find all actors whose last names contain the letters `LI`. This time, 
-- order the rows by last name and first name, in that order:
select first_name, last_name
from actor
where last_name
like('%LI%')
order by last_name, first_name
;

-- * 2d. Using `IN`, display the `country_id` and `country` columns 
-- of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country 
from country
where country 
in ("Afghanistan", "Bangladesh", "China");

-- * 3a. You want to keep a description of each actor. You don't think you will be performing queries
--  on a description, so create a column in the table `actor` named `description` and use the
--  data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
alter table actor
add column description BLOB;

select * from actor;

-- * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
alter table actor 
drop column description;
select * from actor;

-- * 4a. List the last names of actors, as well as how many actors have that last name.
select distinct last_name, count(last_name) 
as unique_last_name
from actor
group by last_name;

-- * 4b. List last names of actors and the number of actors who have that last name,
--  but only for names that are shared by at least two actors
select distinct last_name, count(last_name) 
as unique_last_name
from actor
group by last_name
having count(last_name) >= 2;

-- * 4c. The actor `HARPO WILLIAMS` was accidentally entered in the 
-- `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
update actor
set first_name = "HARPO"
where first_name = "GROUCHO" and last_name = "WILLIAMS";

select first_name, last_name
from actor
where first_name ="HARPO" and last_name = "WILLIAMS";


-- * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO`
-- was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor
set first_name = "GROUCHO"
where first_name = "HARPO" and last_name = "WILLIAMS";

select first_name, last_name
from actor
where first_name ="GROUCHO" and last_name = "WILLIAMS";

-- * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
--   * Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)

show create table address;  


-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
select staff.first_name, staff.last_name, address.address
from staff
inner join address
on staff.address_id = address.address_id;

-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
select staff.first_name, staff.last_name, sum(payment.amount) as total_revenue
from staff
inner join payment
on staff.staff_id = payment.staff_id
where payment.payment_date 
like '2005-08%'
group by staff.staff_id;


-- * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select film.film_id, film.title, count(film_actor.film_id) as actors_listed
from film
inner join film_actor
on film.film_id = film_actor.film_id
group by film.film_id;

-- * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select film.title, count(inventory.film_id) as number_of_copies
from film
inner join inventory
on film.film_id = inventory.film_id
group by film.title
having film.title = "HUNCHBACK IMPOSSIBLE";

-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by 
-- each customer. List the customers alphabetically by last name:
--   ![Total amount paid](Images/total_payment.png)
select customer.first_name, customer.last_name, sum(payment.amount)
from customer 
inner join payment
on customer.customer_id = payment.customer_id
group by customer.first_name
order by customer.last_name;

-- * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters `K` and `Q` have also 
-- soared in popularity. Use subqueries to display the titles of movies starting with 
-- the letters `K` and `Q` whose language is English.
select title from film
where language_id in 
	(select language_id 
	from language
	where name ="ENGLISH") 
and (title like "K%") or (title like "Q%");

-- * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select * from film;
select * from film_actor;
select * from actor;

select first_name, last_name 
from actor
where actor_id in
	(select actor_id 
    from film_actor
    where film_id in
		(select film_id
        from film 
        where title = "ALONE TRIP"
        ));


-- * 7c. You want to run an email marketing campaign in Canada, for which you will need the 
-- names and email addresses of all Canadian customers. Use joins to retrieve this information.
select * from customer limit 10;
select * from address;
select * from city;
select * from country;
select * from city
where country_id = 20;

select * from address
where city_id=179 or city_id=196 or city_id=300 or city_id=313 or city_id=383 or city_id=430 or city_id=565;

select * from customer
where address_id=481 or address_id=468 or address_id=1 or address_id=3 or address_id=193 or address_id=415 or address_id=441;

select customer.first_name, customer.last_name, customer.email, address.district, country.country 
from customer
inner join address
on customer.address_id = address.address_id
inner join city
on address.city_id = city.city_id
inner join country
on city.country_id = country.country_id
where country.country = "CANADA";


select customer.first_name, customer.last_name, sum(payment.amount)
from customer 
inner join payment
on customer.customer_id = payment.customer_id
group by customer.first_name
order by customer.last_name;

-- * 7d. Sales have been lagging among young families, and you wish to target all family movies 
-- for a promotion. Identify all movies categorized as _family_ films.

select * from film;
select * from film_category;
select * from category;

select film.title, category.name as category_name
from film
inner join film_category
on film.film_id = film_category.film_id
inner join category
on film_category.category_id = category.category_id
where category.name = "Family"
group by film.title;

-- * 7e. Display the most frequently rented movies in descending order.
select film.title, count(inventory.inventory_id) as number_times_rented
from film
inner join inventory
on film.film_id = inventory.film_id
inner join rental
on inventory.inventory_id = rental.inventory_id
group by film.title
order by count(inventory.inventory_id) desc;

SELECT 
    film.title, COUNT(*) AS 'count'
FROM
    film,
    inventory,
    rental
WHERE
    film.film_id = inventory.film_id
        AND rental.inventory_id = inventory.inventory_id
GROUP BY inventory.film_id
ORDER BY COUNT(*) DESC, film.title ASC;

-- * 7f. Write a query to display how much business, in dollars, each store brought in.
select staff.store_id as store, sum(payment.amount) as revenue
from staff 
inner join payment
on staff.staff_id = payment.staff_id
group by staff.store_id;

-- * 7g. Write a query to display for each store its store ID, city, and country.
select store.store_id, city.city, country.country
from store
inner join address 
on store.address_id = address.address_id
inner join city 
on address.city_id = city.city_id
inner join country 
on city.country_id = country.country_id;

-- * 7h. List the top five genres in gross revenue in descending order. 
-- (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select category.name, sum(payment.amount) as revenue
from category
inner join film_category
on category.category_id = film_category.category_id
inner join inventory
on inventory.film_id = film_category.film_id
inner join rental 
on rental.inventory_id = inventory.inventory_id
inner join payment 
on payment.rental_id = rental.rental_id
group by category.name
order by revenue desc
limit 5;

-- * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres 
-- by gross revenue. Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.

drop view if exists top_genres;

create view top_genres as 
select category.name, sum(payment.amount) as revenue
from category
inner join film_category
on category.category_id = film_category.category_id
inner join inventory
on inventory.film_id = film_category.film_id
inner join rental 
on rental.inventory_id = inventory.inventory_id
inner join payment 
on payment.rental_id = rental.rental_id
group by category.name
order by revenue desc
limit 5;

-- * 8b. How would you display the view that you created in 8a?
select * 
from top_genres;

-- * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view top_genres;




