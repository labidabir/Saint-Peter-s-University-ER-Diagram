-- Enable foreign keys
PRAGMA foreign_keys = ON;

-- Drop tables in safe order (so script can be re-run)
DROP TABLE IF EXISTS fines;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS copies;
DROP TABLE IF EXISTS patrons;
DROP TABLE IF EXISTS branches;
DROP TABLE IF EXISTS book_authors;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;

--------------------------------------------------------
-- AUTHORS
--------------------------------------------------------
CREATE TABLE authors (
  author_id   INTEGER PRIMARY KEY AUTOINCREMENT,
  first_name  TEXT NOT NULL,
  last_name   TEXT NOT NULL,
  birth_year  INTEGER,
  death_year  INTEGER,
  CHECK (birth_year IS NULL OR birth_year > 1000),
  CHECK (death_year IS NULL OR death_year >= birth_year)
);

--------------------------------------------------------
-- BOOKS
--------------------------------------------------------
CREATE TABLE books (
  book_id          INTEGER PRIMARY KEY AUTOINCREMENT,
  isbn             TEXT UNIQUE,
  title            TEXT NOT NULL,
  publication_year INTEGER,
  publisher        TEXT,
  pages            INTEGER CHECK (pages IS NULL OR pages > 0)
);

--------------------------------------------------------
-- BOOK_AUTHORS (many-to-many)
--------------------------------------------------------
CREATE TABLE book_authors (
  book_id     INTEGER NOT NULL,
  author_id   INTEGER NOT NULL,
  author_order INTEGER NOT NULL DEFAULT 1,
  PRIMARY KEY (book_id, author_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
  FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE,
  CHECK (author_order >= 1)
);

--------------------------------------------------------
-- BRANCHES
--------------------------------------------------------
CREATE TABLE branches (
  branch_id   INTEGER PRIMARY KEY AUTOINCREMENT,
  branch_name TEXT NOT NULL UNIQUE,
  address     TEXT
);

--------------------------------------------------------
-- PATRONS
--------------------------------------------------------
CREATE TABLE patrons (
  patron_id   INTEGER PRIMARY KEY AUTOINCREMENT,
  card_number TEXT NOT NULL UNIQUE,
  first_name  TEXT,
  last_name   TEXT,
  email       TEXT UNIQUE,
  phone       TEXT,
  status      TEXT NOT NULL DEFAULT 'active' 
              CHECK (status IN ('active','suspended','closed')),
  join_date   DATE DEFAULT (date('now'))
);

--------------------------------------------------------
-- COPIES
--------------------------------------------------------
CREATE TABLE copies (
  copy_id    INTEGER PRIMARY KEY AUTOINCREMENT,
  book_id    INTEGER NOT NULL,
  branch_id  INTEGER NOT NULL,
  barcode    TEXT NOT NULL UNIQUE,
  acquisition_date DATE,
  condition  TEXT,
  is_reference INTEGER NOT NULL DEFAULT 0 CHECK (is_reference IN (0,1)),
  FOREIGN KEY (book_id) REFERENCES books(book_id),
  FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

--------------------------------------------------------
-- LOANS
--------------------------------------------------------
CREATE TABLE loans (
  loan_id     INTEGER PRIMARY KEY AUTOINCREMENT,
  copy_id     INTEGER NOT NULL,
  patron_id   INTEGER NOT NULL,
  loan_date   DATE NOT NULL DEFAULT (date('now')),
  due_date    DATE NOT NULL,
  return_date DATE,
  status      TEXT NOT NULL DEFAULT 'out' 
              CHECK (status IN ('out','returned','lost')),
  FOREIGN KEY (copy_id) REFERENCES copies(copy_id),
  FOREIGN KEY (patron_id) REFERENCES patrons(patron_id),
  CHECK (return_date IS NULL OR return_date >= loan_date),
  CHECK (due_date >= loan_date)
);

--------------------------------------------------------
-- FINES
--------------------------------------------------------
CREATE TABLE fines (
  fine_id     INTEGER PRIMARY KEY AUTOINCREMENT,
  loan_id     INTEGER NOT NULL,
  amount      REAL NOT NULL DEFAULT 0.0 CHECK (amount >= 0),
  paid        INTEGER NOT NULL DEFAULT 0 CHECK (paid IN (0,1)),
  assessed_date DATE DEFAULT (date('now')),
  FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE CASCADE
);

--------------------------------------------------------
-- INDEXES (for faster reporting)
--------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_loans_patron ON loans(patron_id);
CREATE INDEX IF NOT EXISTS idx_loans_copy ON loans(copy_id);
CREATE INDEX IF NOT EXISTS idx_copies_book_branch ON copies(book_id, branch_id);

SELECT * FROM authors_1;
SELECT * FROM book_authors_1;
SELECT * FROM books_1;
SELECT * FROM branches_1;
SELECT * FROM copies_1;
SELECT * FROM fines_1;
SELECT * FROM loans_1;
SELECT * FROM patrons_1;