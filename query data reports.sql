-- Week 6 — Data Quality Checks
-- Author: Labannya Debnath
-- Date: October 24, 2025

-- 1️ Check for NULL primary keys in main tables
SELECT 'authors_1' AS table_name, COUNT(*) AS null_ids
FROM authors_1 WHERE c1 IS NULL
UNION ALL
SELECT 'books_1', COUNT(*) FROM books_1 WHERE c1 IS NULL
UNION ALL
SELECT 'patrons_1', COUNT(*) FROM patrons_1 WHERE c1 IS NULL
UNION ALL
SELECT 'loans_1', COUNT(*) FROM loans_1 WHERE c1 IS NULL;

-- 2️ Check for duplicate ISBNs in books
SELECT c2 AS isbn, COUNT(*) AS duplicate_count
FROM books_1
GROUP BY c2
HAVING COUNT(*) > 1;

-- 3️ Check for invalid foreign keys in book_authors (book_id that doesn’t exist in books)
SELECT ba.c1 AS book_author_id
FROM book_authors_1 ba
LEFT JOIN books_1 b ON ba.c1 = b.c1
WHERE b.c1 IS NULL;

-- 4️ Check for negative or invalid fines
SELECT *
FROM fines_1
WHERE c3 < 0;

-- 5️ Check for loans where due_date < checkout_date
SELECT *
FROM loans_1
WHERE c5 < c4;
