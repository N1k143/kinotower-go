CREATE TABLE IF NOT EXISTS gender (
    id SERIAL PRIMARY KEY,
    name VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL,
    deleted_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    fio VARCHAR(50) NOT NULL,
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE SET NULL,
    birthday DATE NOT NULL,
    gender_id INT,
    FOREIGN KEY (gender_id) REFERENCES gender(id) ON DELETE SET NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS films (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE SET NULL,
    duration INT NOT NULL,
    year_of_issue INT NOT NULL CHECK (year_of_issue >= 1888),
    age INT NOT NULL CHECK (age >= 0),
    link_img VARCHAR(255) NULL,
    link_kinopoisk VARCHAR(255) NULL,
    link_video VARCHAR(255) NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS categories_films (
    id SERIAL PRIMARY KEY,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    film_id INT,
    FOREIGN KEY (film_id) REFERENCES films(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ratings (
    id SERIAL PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    film_id INT,
    FOREIGN KEY (film_id) REFERENCES films(id) ON DELETE CASCADE,
    ball INT NOT NULL CHECK (ball >= 0),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS reviews (
    id SERIAL PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    film_id INT,
    FOREIGN KEY (film_id) REFERENCES films(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    is_approved BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMPTZ
);

INSERT INTO gender (name) VALUES
('Male'),
('Female'),
('Other');

INSERT INTO countries (name) VALUES
('USA'),
('Russia'),
('France'),
('Germany'),
('Italy'),
('Japan');

INSERT INTO categories (name, parent_id) VALUES
('Action', NULL),
('Comedy', NULL),
('Drama', NULL),
('Sci-Fi', NULL),
('Horror', NULL),
('Romance', NULL),
('Thriller', NULL),
('Adventure', NULL),
('Animation', NULL),
('Fantasy', NULL);

INSERT INTO categories (name, parent_id) VALUES
('Superhero', (SELECT id FROM categories WHERE name = 'Action')),
('Slapstick', (SELECT id FROM categories WHERE name = 'Comedy')),
('Historical', (SELECT id FROM categories WHERE name = 'Drama')),
('Cyberpunk', (SELECT id FROM categories WHERE name = 'Sci-Fi')),
('Psychological', (SELECT id FROM categories WHERE name = 'Horror')),
('Romantic Comedy', (SELECT id FROM categories WHERE name = 'Romance')),
('Crime Thriller', (SELECT id FROM categories WHERE name = 'Thriller')),
('Fantasy Adventure', (SELECT id FROM categories WHERE name = 'Adventure')),
('3D Animation', (SELECT id FROM categories WHERE name = 'Animation')),
('Epic Fantasy', (SELECT id FROM categories WHERE name = 'Fantasy'));

INSERT INTO users (fio, birthday, email, password, gender_id) VALUES
('John Doe', '1990-01-01', 'john.doe@example.com', 'password123', (SELECT id FROM gender WHERE name = 'Male')),
('Jane Smith', '1985-05-15', 'jane.smith@example.com', 'password456', (SELECT id FROM gender WHERE name = 'Female'));

INSERT INTO films (name, country_id, duration, year_of_issue, age, link_img, link_kinopoisk, link_video) VALUES
('Inception', (SELECT id FROM countries WHERE name = 'USA'), 148, 2010, 13, 'https://example.com/inception.jpg', 'https://www.kinopoisk.ru/film/447301/', 'https://example.com/inception.mp4'),
('The Matrix', (SELECT id FROM countries WHERE name = 'USA'), 136, 1999, 16, 'https://example.com/matrix.jpg', 'https://www.kinopoisk.ru/film/301/', 'https://example.com/matrix.mp4'),
('Amelie', (SELECT id FROM countries WHERE name = 'France'), 122, 2001, 12, 'https://example.com/amelie.jpg', 'https://www.kinopoisk.ru/film/12345/', 'https://example.com/amelie.mp4'),
('Spirited Away', (SELECT id FROM countries WHERE name = 'Japan'), 125, 2001, 10, 'https://example.com/spirited_away.jpg', 'https://www.kinopoisk.ru/film/67890/', 'https://example.com/spirited_away.mp4'),
('The Godfather', (SELECT id FROM countries WHERE name = 'USA'), 175, 1972, 18, 'https://example.com/godfather.jpg', 'https://www.kinopoisk.ru/film/123456/', 'https://example.com/godfather.mp4'),
('City of God', (SELECT id FROM countries WHERE name = 'USA'), 130, 2002, 16, 'https://example.com/city_of_god.jpg', 'https://www.kinopoisk.ru/film/654321/', 'https://example.com/city_of_god.mp4'),
('Pulp Fiction', (SELECT id FROM countries WHERE name = 'USA'), 154, 1994, 18, 'https://example.com/pulp_fiction.jpg', 'https://www.kinopoisk.ru/film/789012/', 'https://example.com/pulp_fiction.mp4'),
('The Shawshank Redemption', (SELECT id FROM countries WHERE name = 'USA'), 142, 1994, 16, 'https://example.com/shawshank.jpg', 'https://www.kinopoisk.ru/film/654321/', 'https://example.com/shawshank.mp4'),
('The Dark Knight', (SELECT id FROM countries WHERE name = 'USA'), 152, 2008, 13, 'https://example.com/dark_knight.jpg', 'https://www.kinopoisk.ru/film/1234567/', 'https://example.com/dark_knight.mp4'),
('Forrest Gump', (SELECT id FROM countries WHERE name = 'USA'), 142, 1994, 13, 'https://example.com/forrest_gump.jpg', 'https://www.kinopoisk.ru/film/7890123/', 'https://example.com/forrest_gump.mp4'),
('Superman', (SELECT id FROM countries WHERE name = 'USA'), 140, 2025, 12, 'https://example.com/superman.jpg', NULL, NULL),
('The Green Elephant', (SELECT id FROM countries WHERE name = 'Russia'), 90, 1999, 18, 'https://example.com/green_elephant.jpg', NULL, NULL),
('Sin City', (SELECT id FROM countries WHERE name = 'USA'), 124, 2005, 18, 'https://example.com/sin_city.jpg', NULL, NULL),
('The Lighthouse', (SELECT id FROM countries WHERE name = 'USA'), 109, 2019, 18, 'https://example.com/lighthouse.jpg', NULL, NULL),
('Taxi Driver', (SELECT id FROM countries WHERE name = 'USA'), 114, 1976, 18, 'https://example.com/taxi_driver.jpg', NULL, NULL),
('The Shining', (SELECT id FROM countries WHERE name = 'USA'), 146, 1980, 18, 'https://example.com/shining.jpg', NULL, NULL),
('The Whale', (SELECT id FROM countries WHERE name = 'USA'), 117, 2022, 16, 'https://example.com/whale.jpg', NULL, NULL),
('The Godfather Part I', (SELECT id FROM countries WHERE name = 'USA'), 175, 1972, 18, 'https://example.com/godfather2.jpg', NULL, NULL),
('A Clockwork Orange', (SELECT id FROM countries WHERE name = 'USA'), 136, 1971, 18, 'https://example.com/clockwork_orange.jpg', NULL, NULL);

INSERT INTO categories_films (film_id, category_id) VALUES
((SELECT id FROM films WHERE name = 'Inception'), (SELECT id FROM categories WHERE name = 'Sci-Fi')),
((SELECT id FROM films WHERE name = 'The Matrix'), (SELECT id FROM categories WHERE name = 'Sci-Fi')),
((SELECT id FROM films WHERE name = 'Amelie'), (SELECT id FROM categories WHERE name = 'Romantic Comedy')),
((SELECT id FROM films WHERE name = 'Spirited Away'), (SELECT id FROM categories WHERE name = 'Fantasy Adventure')),
((SELECT id FROM films WHERE name = 'The Godfather'), (SELECT id FROM categories WHERE name = 'Crime Thriller')),
((SELECT id FROM films WHERE name = 'City of God'), (SELECT id FROM categories WHERE name = 'Crime Thriller')),
((SELECT id FROM films WHERE name = 'Pulp Fiction'), (SELECT id FROM categories WHERE name = 'Crime Thriller')),
((SELECT id FROM films WHERE name = 'The Shawshank Redemption'), (SELECT id FROM categories WHERE name = 'Drama')),
((SELECT id FROM films WHERE name = 'The Dark Knight'), (SELECT id FROM categories WHERE name = 'Superhero')),
((SELECT id FROM films WHERE name = 'Forrest Gump'), (SELECT id FROM categories WHERE name = 'Drama')),
((SELECT id FROM films WHERE name = 'Forrest Gump'), (SELECT id FROM categories WHERE name = 'Comedy')),
((SELECT id FROM films WHERE name = 'Forrest Gump'), (SELECT id FROM categories WHERE name = 'Romance')),
((SELECT id FROM films WHERE name = 'Superman'), (SELECT id FROM categories WHERE name = 'Superhero')),
((SELECT id FROM films WHERE name = 'The Green Elephant'), (SELECT id FROM categories WHERE name = 'Psychological')),
((SELECT id FROM films WHERE name = 'Sin City'), (SELECT id FROM categories WHERE name = 'Crime Thriller')),
((SELECT id FROM films WHERE name = 'The Lighthouse'), (SELECT id FROM categories WHERE name = 'Horror')),
((SELECT id FROM films WHERE name = 'Taxi Driver'), (SELECT id FROM categories WHERE name = 'Drama')),
((SELECT id FROM films WHERE name = 'The Shining'), (SELECT id FROM categories WHERE name = 'Horror')),
((SELECT id FROM films WHERE name = 'The Whale'), (SELECT id FROM categories WHERE name = 'Drama')),
((SELECT id FROM films WHERE name = 'The Godfather Part I'), (SELECT id FROM categories WHERE name = 'Crime Thriller')),
((SELECT id FROM films WHERE name = 'A Clockwork Orange'), (SELECT id FROM categories WHERE name = 'Sci-Fi'));