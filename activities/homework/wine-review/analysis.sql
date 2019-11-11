/*
 Instructions:
    - Create a branch named "wine"
    - Solve the data-requests from this file using SQL.
    - Add/Commit/Push your changes to github (individual).
 Note: You can work along with your project team.
 */

-- EX.1) Get the top 10 countries with more population density
SELECT
    name,
    population / area_km2 density
FROM
    country c
WHERE
    area_km2 > 0
ORDER BY density DESC
LIMIT 10
;
-- EX.2) Get the count of male/female tasters.
SELECT
    gender,
    count(*)
FROM
     taster
WHERE
    LOWER(gender) in ('male','female')
GROUP BY gender
;

-- EX.3) Get the percentage of male/female tasters.
WITH taster_valid AS (
    SELECT
        *
    FROM
        taster
    WHERE
        LOWER(gender) IN ('male','female')
    ), taster_gender_agg AS (
    SELECT
           gender,
           COUNT(*)::NUMERIC(7, 2) gender_sum
    FROM
         taster_valid
    GROUP BY
        gender
    ),taster_total AS (
    SELECT
           count(*)::NUMERIC(7, 2) total
    FROM taster_valid
    )
SELECT
    gender,
    TRUNC(100 * gender_sum/total,2) percentage
FROM
    taster_gender_agg,
    taster_total
;

-- EX.4) How many countries share the same first digit on their country-code?
-- Show only those digits with more than 20 countries.
SELECT DISTINCT LEFT(code,1) FROM country;

SELECT
    LEFT(code, 1) first_digit,
    count(*) country_count
FROM
    country
GROUP BY
    first_digit
HAVING
    count(*) > 20
;

-- EX.5) Get the % of countries are not labeled as a trillion usd gdp and
-- do have a null happiness_score.
SELECT * FROM country;

SELECT
    100 * COUNT(*) / MAX(t.total) Percentage
FROM
     country,
    (SELECT count(*) total FROM country) t
WHERE
    LOWER(gdp_usd) NOT LIKE '%trillion'
AND happiness_score IS NULL
;

-- COUNTRY ANALYSIS

-- A) Get the average happiness_score of the countries labeled with a GDP
-- of "billion" and "trillion".
SELECT * FROM country;
SELECT
    AVG(happiness_score)
FROM
    country
WHERE
    LOWER(SPLIT_PART(gdp_usd, ' ', 2)) IN ('billion', 'trillion')
;


-- B) Show a table with the country name, population, area, gdp, and happiness core of the
-- the G7 countries (i.e., `Canada`, `France`, `Germany`, `Italy`, `Japan`, `United Kingdom`, `United States`)
-- order by happiness_score (DESC).
SELECT
    name,
    population,
    area_km2,
    gdp_usd,
    happiness_score
FROM
    country
WHERE name IN
      ('Canada','France','Germany','Italy','Japan','United Kingdom','United States')
ORDER by
    happiness_score DESC
;

-- C) Create a custom score called "score" using this formula: happiness_score * density
-- Where `density` is population / area_km2. Show the top 10 countries (name) with greater score.
WITH
    country_density AS (SELECT name, DIV(population,area_km2) AS "den"
FROM
    country
WHERE
    area_km2>0),
    country_score AS (SELECT name, happiness_score FROM country WHERE area_km2 > 0)
SELECT
    country_score.name,(country_score.happiness_score * country_density.den) AS score
FROM
    country_density, country_score
WHERE
    country_score.name = country_density.name
AND (country_score.happiness_score * country_density.den) IS NOT NULL ORDER BY score DESC LIMIT 10
;


-- WINE ANALYSIS

-- D) Get the number of wines per variety, ordered by the latter (desc)
SELECT
    variety,
    COUNT(variety)
FROM
    wine
GROUP BY
    variety
ORDER BY
    COUNT(variety) DESC
;

-- E) How many wines are registered per country? Show country name and number of wines, ordered by the latter (desc).
SELECT
    name,
    COUNT(name)
FROM
    wine JOIN country on wine.country_id = country.id
GROUP BY
    name
ORDER BY
    COUNT(name) DESC
;


-- REVIEW ANALYSIS

-- F) What's the average wine price and points per province?
-- Show the province, avg-price, avg-points when the avg-points are grater than 85.
-- Ordered by avg-price and then by avg-points.
SELECT
    province,
    AVG(price) AS "price",
    AVG(points) AS "points"
FROM
    review
    JOIN wine on review.wine_id = wine.id
GROUP BY
    province
HAVING
    AVG(points) > 85
ORDER BY
    AVG(price) DESC, AVG(points) DESC
;


-- G) What's the average wine price and points of the countries with more than a 7 in their happiness score?
-- Show the country, avg-price, avg-points.
-- Ordered by avg-points and then by avg-price.
SELECT
    name,
    AVG(points) AS "points",
    AVG(price) AS "price"
FROM
    review
    JOIN wine on review.wine_id = wine.id
    JOIN country on wine.country_id = country.id
GROUP BY
    name,
    happiness_score
HAVING
    happiness_score > 7
ORDER BY
    AVG(points) DESC, AVG(price) DESC
;


-- H) What's the min, avg, and max wine points per taster gender (excluding undefined) and wine variety starting with "Cabernet".
-- Order by: variety, gender
SELECT
    variety,
    gender,
    MIN(points) AS "min points",
    AVG(points) AS "avg points",
    MAX(points) AS "max points"
FROM
    review
    JOIN wine on review.wine_id = wine.id
    JOIN taster on review.taster_id = taster.id
WHERE
    LOWER(gender) NOT IN ('undefined') AND variety LIKE 'Cabernet%'
GROUP BY
    variety,
    gender
ORDER BY
    variety,
    gender
;


-- I) Create the following custom score called "wine_quality_and_happiness_index": happiness_score * avg(points) / 100
-- Get the score per country and order by the value (desc).
SELECT
    name,
    (AVG(happiness_score) * AVG(points) / 100) AS wine_quality_and_happiness_index
FROM
    country
    JOIN wine on country.id = wine.country_id
    JOIN review on wine.id = review.wine_id
GROUP BY
    name
ORDER BY wine_quality_and_happiness_index DESC
;

