CREATE TABLE `authors` (
  `author_id` INTEGER PRIMARY KEY AUTO_INCREMENT,
  `first_name` TEXT,
  `last_name` TEXT,
  `birth_year` INTEGER COMMENT 'NULL if unknown'
);

CREATE TABLE `books` (
  `book_id` INTEGER PRIMARY KEY AUTO_INCREMENT,
  `isbn` TEXT UNIQUE NOT NULL,
  `title` TEXT NOT NULL,
  `publication_year` INTEGER,
  `publisher` TEXT,
  `pages` INTEGER
);

CREATE TABLE `book_authors` (
  `book_id` INTEGER,
  `author_id` INTEGER,
  `author_order` INTEGER
);

CREATE TABLE `branches` (
  `branch_id` INTEGER PRIMARY KEY AUTO_INCREMENT,
  `branch_name` TEXT UNIQUE NOT NULL,
  `address` TEXT
);

CREATE TABLE `patrons` (
  `patron_id` INTEGER PRIMARY KEY AUTO_INCREMENT,
  `card_number` TEXT UNIQUE NOT NULL,
  `first_name` TEXT,
  `last_name` TEXT,
  `email` TEXT UNIQUE,
  `phone` TEXT,
  `status` TEXT NOT NULL DEFAULT 'active'
);

CREATE TABLE `copies` (
  `copy_id` INTEGER PRIMARY KEY AUTO_INCREMENT,
  `book_id` INTEGER,
  `branch_id` INTEGER,
  `barcode` TEXT UNIQUE NOT NULL,
  `acquisition_date` DATE,
  `condition` TEXT,
  `is_reference` INTEGER DEFAULT 0
);

CREATE TABLE `loans` (
  `loan_id` INTEGER PRIMARY KEY AUTO_INCREMENT,
  `copy_id` INTEGER,
  `patron_id` INTEGER,
  `loan_date` DATE NOT NULL,
  `due_date` DATE NOT NULL,
  `return_date` DATE,
  `status` TEXT NOT NULL DEFAULT 'out'
);

CREATE TABLE `fines` (
  `fine_id` INTEGER PRIMARY KEY AUTO_INCREMENT,
  `loan_id` INTEGER,
  `amount` REAL NOT NULL DEFAULT 0,
  `paid` INTEGER NOT NULL DEFAULT 0,
  `assessed_date` DATE
);

CREATE UNIQUE INDEX `book_authors_index_0` ON `book_authors` (`book_id`, `author_id`);

ALTER TABLE `book_authors` ADD FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`);

ALTER TABLE `book_authors` ADD FOREIGN KEY (`author_id`) REFERENCES `authors` (`author_id`);

ALTER TABLE `copies` ADD FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`);

ALTER TABLE `copies` ADD FOREIGN KEY (`branch_id`) REFERENCES `branches` (`branch_id`);

ALTER TABLE `loans` ADD FOREIGN KEY (`copy_id`) REFERENCES `copies` (`copy_id`);

ALTER TABLE `loans` ADD FOREIGN KEY (`patron_id`) REFERENCES `patrons` (`patron_id`);

ALTER TABLE `fines` ADD FOREIGN KEY (`loan_id`) REFERENCES `loans` (`loan_id`);
