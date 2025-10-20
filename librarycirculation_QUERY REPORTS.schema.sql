select * from authors_1;
SELECT * FROM book_authors_1;
SELECT * FROM branches_1;
SELECT * FROM books_1;
SELECT * FROM copies_1;
SELECT * FROM fines_1;
SELECT * FROM loans_1;
SELECT * FROM patrons_1;
SELECT 
    a.c1 AS author_id,
    a.c2 AS first_name,
    a.c3 AS last_name,
    COUNT(ba.c1) AS book_count
FROM authors_1 a
LEFT JOIN book_authors_1 ba ON a.c1 = ba.c2
GROUP BY a.c1, a.c2, a.c3
ORDER BY book_count DESC, a.c3 ASC;

SELECT 
    b.c1 AS branch_id,
    b.c2 AS branch_name,
    b.c3 AS address,
    COUNT(l.c1) AS total_loans
FROM branches_1 b
LEFT JOIN loans_1 l ON b.c1 = l.c4
GROUP BY b.c1, b.c2, b.c3
ORDER BY total_loans DESC;

SELECT 
    COUNT(CASE WHEN l.c7 IS NULL AND l.c6 < date('now') THEN 1 END) AS overdue_loans,
    COUNT(*) AS total_loans,
    ROUND(
        100.0 * COUNT(CASE WHEN l.c7 IS NULL AND l.c6 < date('now') THEN 1 END) / 
        CAST(COUNT(*) AS FLOAT), 
        2
    ) AS overdue_percentage
FROM loans_1 l;
SELECT 
    b.c1 AS book_id,
    b.c3 AS title,
    b.c2 AS isbn,
    b.c4 AS publication_year,
    COUNT(l.c1) AS checkout_count
FROM books_1 b
LEFT JOIN loans_1 l ON b.c1 = l.c2
GROUP BY b.c1, b.c3, b.c2, b.c4
ORDER BY checkout_count DESC, b.c3 ASC
LIMIT 10;
SELECT 
    p.c1 AS patron_id,
    p.c2 AS card_number,
    p.c3 AS first_name,
    p.c4 AS last_name,
    p.c7 AS status,
    COUNT(l.c1) AS total_checkouts,
    SUM(CASE WHEN f.c4 = 0 THEN f.c3 ELSE 0 END) AS unpaid_fines
FROM patrons_1 p
LEFT JOIN loans_1 l ON p.c1 = l.c3
LEFT JOIN fines_1 f ON l.c1 = f.c2
GROUP BY p.c1, p.c2, p.c3, p.c4, p.c7
ORDER BY total_checkouts DESC;
SELECT 
    COUNT(*) AS total_fines,
    SUM(c3) AS total_amount_assessed,
    SUM(CASE WHEN c4 = 1 THEN c3 ELSE 0 END) AS total_paid,
    SUM(CASE WHEN c4 = 0 THEN c3 ELSE 0 END) AS total_outstanding,
    ROUND(100.0 * SUM(CASE WHEN c4 = 1 THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT), 2) AS payment_rate_percentage
FROM fines_1;
SELECT 
    (c4 / 10) * 10 AS decade,
    COUNT(*) AS book_count,
    AVG(c6) AS avg_pages
FROM books_1
GROUP BY decade
ORDER BY decade DESC;

SELECT 
    c7 AS status,
    COUNT(*) AS patron_count,
    ROUND(100.0 * COUNT() / (SELECT COUNT() FROM patrons_1), 2) AS percentage
FROM patrons_1
GROUP BY c7
ORDER BY patron_count
DESC;
