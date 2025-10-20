EXPLAIN QUERY PLAN
SELECT 
    b.c1 AS book_id,
    b.c3 AS title,
    COUNT(l.c1) AS checkout_count
FROM books_1 b
LEFT JOIN loans_1 l ON b.c1 = l.c2
GROUP BY b.c1, b.c3
ORDER BY checkout_count DESC
LIMIT 10;
EXPLAIN QUERY PLAN
SELECT 
    p.c1 AS patron_id,
    p.c3 AS first_name,
    p.c4 AS last_name,
    COUNT(l.c1) AS total_loans
FROM patrons_1 p
LEFT JOIN loans_1 l ON p.c1 = l.c3
GROUP BY p.c1, p.c3, p.c4
ORDER BY total_loans DESC;
