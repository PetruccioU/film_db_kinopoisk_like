-- film_db_kinopoisk_like:

-- создадим таблицы, одна запись которых будет соответствовать одной записи в таблице film,
-- это таблицы: video_quality(качество видео), age_rate(возрастной рейтинг), MPAA_rate (рейтинг MPAA)

CREATE TABLE video_quality (
    id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    video_quality_name VARCHAR(50) UNIQUE NOT NULL, 
    video_quality_description VARCHAR(250) UNIQUE NOT NULL,
    CONSTRAINT PK_video_quality_id PRIMARY KEY (id)
);

CREATE TABLE age_rate (
    id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    age_rate_name VARCHAR(50) UNIQUE NOT NULL, 
    age_rate_description VARCHAR(250) UNIQUE NOT NULL,
    CONSTRAINT PK_age_rate_id PRIMARY KEY (id)
);

CREATE TABLE mpaa_rate (
    id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    mpaa_rate_name VARCHAR(50) UNIQUE NOT NULL, 
    mpaa_rate_description VARCHAR(250) UNIQUE NOT NULL,
    CONSTRAINT PK_mpaa_rate_id PRIMARY KEY (id)
);  

-- создадим основную таблицу с информацией о фильмах:
-- в ней будем хранить уникальные данные о фильмах(такие как оценки зрителей, кассовые сборы и тд)
-- и внешние ключи

CREATE TABLE film (
    id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    score INTEGER NOT NULL,
    ratings INTEGER NOT NULL,
    reviews INTEGER NOT NULL, 
    title VARCHAR(50) UNIQUE NOT NULL, 
    short_description VARCHAR(250) UNIQUE NOT NULL,
    year_of_production INTEGER NOT NULL,    
    video_quality_id INTEGER NOT NULL,
    FOREIGN KEY ("video_quality_id")  REFERENCES "video_quality" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
    tagline VARCHAR(100),
    budget INTEGER NOT NULL,
    marketing INTEGER NOT NULL,
    cash_us INTEGER NOT NULL,
    cash_world INTEGER NOT NULL,
    relise_date_ru DATE,
    relise_date_world DATE,
    relise_date_dvd DATE,
    age_rate_id INTEGER NOT NULL,
    FOREIGN KEY ("age_rate_id") REFERENCES "age_rate" ("id") ON UPDATE CASCADE ON DELETE CASCADE,    
    mpaa_rate_id INTEGER NOT NULL,
    FOREIGN KEY ("mpaa_rate_id") REFERENCES "mpaa_rate" ("id") ON UPDATE CASCADE ON DELETE CASCADE,    
    duration INTEGER NOT NULL,
    CONSTRAINT PK_film_id PRIMARY KEY (id)
);    

-- создадим таблицы, многие записи которых будет соответствовать одной записи в таблице film,
-- это таблицы: film_person(создатели фильма, и их должности), film_genre(жанры фильма)
-- film_countries_views(просмотры фильма по странам), country_of_production(страны производства фильма),
-- film_audio_track(какие у фильма звуковые дорожки), film_subtitles(субтитры фильма).
-- дополнительные поля (person_position, country_views) в этих таблицах будут хранить 
-- уникальные значения в зависимости от фильма.

CREATE TABLE film_person (
    id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    film_person_name VARCHAR(50) NOT NULL, 
    film_person_position VARCHAR(250) NOT NULL,
    film_id INTEGER NOT NULL,
    FOREIGN KEY ("film_id") REFERENCES "film" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK_film_person_id PRIMARY KEY (id)
);

CREATE TABLE film_genre (
    id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    film_genre_name VARCHAR(50) NOT NULL, 
    film_id INTEGER NOT NULL,
    FOREIGN KEY ("film_id") REFERENCES "film" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK_film_genre_id PRIMARY KEY (id)
);

CREATE TABLE film_countries_views (
    id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    country_name VARCHAR(50) NOT NULL, 
    country_views INTEGER NOT NULL,
    film_id INTEGER NOT NULL,
    FOREIGN KEY ("film_id") REFERENCES "film" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK_film_countries_views_id PRIMARY KEY (id)
);

CREATE TABLE film_country_of_production (
    id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    country_name VARCHAR(50) NOT NULL, 
    film_id INTEGER NOT NULL,
    FOREIGN KEY ("film_id") REFERENCES "film" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK_film_country_of_production_id PRIMARY KEY (id)
);

CREATE TABLE film_audio_track (
    id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    audio_track_language VARCHAR(50) NOT NULL, 
    film_id INTEGER NOT NULL,
    FOREIGN KEY ("film_id") REFERENCES "film" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK_film_audio_track_id PRIMARY KEY (id)
);

CREATE TABLE film_subtitles (
    id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    subtitles_language VARCHAR(50) NOT NULL, 
    film_id INTEGER NOT NULL,
    FOREIGN KEY ("film_id") REFERENCES "film" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK_film_subtitles_id PRIMARY KEY (id)
);

-- создадим таблицы, имеющие связь многие ко многим с основной таблицей film, 
-- это таблицы: mainroles(главные роли) связана с film через film_mainroles, 
-- dubbingroles(актеры дубляжа) связана с film через film_dubbingroles. Дополнительная
-- информация по актерам будет храниться в таблицах mainroles и dubbingroles, не повторяясь.

CREATE TABLE mainroles (
    id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    mainrole_name VARCHAR(50) UNIQUE NOT NULL,
    mainrole_biography VARCHAR(250) UNIQUE NOT NULL,
    CONSTRAINT PK_mainroles_id PRIMARY KEY (id)
);

CREATE TABLE film_mainroles (
    id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    film_id INTEGER NOT NULL,
    mainrole_id INTEGER NOT NULL,
    FOREIGN KEY ("film_id") REFERENCES "film" ("id"),
    FOREIGN KEY ("mainrole_id") REFERENCES "mainroles" ("id"),
    CONSTRAINT PK_film_mainroles_id PRIMARY KEY (id)
);

CREATE TABLE dubbingroles (
    id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    dubbingrole_name VARCHAR(50) UNIQUE NOT NULL,
    dubbingrole_biography VARCHAR(250) UNIQUE NOT NULL,
    CONSTRAINT PK_dubbingroles_id PRIMARY KEY (id)
);

CREATE TABLE film_dubbingroles (
    id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    film_id INTEGER NOT NULL,
    dubbingrole_id INTEGER NOT NULL,
    FOREIGN KEY ("film_id") REFERENCES "film" ("id"),
    FOREIGN KEY ("dubbingrole_id") REFERENCES "dubbingroles" ("id"),
    CONSTRAINT PK_film_dubbingroles_id PRIMARY KEY (id)
);