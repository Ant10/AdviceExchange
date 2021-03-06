
-- Table of User

  DROP TABLE IF EXISTS user;
  CREATE TABLE user (

    user_id         INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1) PRIMARY KEY,
    user_name       VARCHAR_IGNORECASE(50)   NOT NULL,
    user_age        INT,
    user_about_me   LONGVARCHAR,
    user_joined     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_location   VARCHAR(120),
    user_site       VARCHAR(70),
    user_email      VARCHAR(50)  NOT NULL,
    user_password   VARCHAR(32)  NOT NULL,
    user_enabled    BOOLEAN DEFAULT TRUE NOT NULL,
    user_reputation INT DEFAULT 1 NOT NULL,

    UNIQUE (user_email)
  );


-- Table of Badge

  DROP TABLE IF EXISTS badge;
  CREATE TABLE badge (

    bdg_id   INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1) PRIMARY KEY,
    bdg_name VARCHAR(10)  NOT NULL,
    bdg_desc VARCHAR(100) NOT NULL,

    UNIQUE (bdg_name)
  );


-- Table reference for User and Badges (many to many)

  DROP TABLE IF EXISTS user_badge;
  CREATE TABLE user_badge (

    ub_badge_id INT NOT NULL,
    ub_user_id  INT NOT NULL
  );


-- Table of UserActivity

DROP TABLE IF EXISTS user_activity;
CREATE TABLE user_activity (

  ua_id      INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1) PRIMARY KEY,
  ua_type    VARCHAR(30)                         NOT NULL,
  ua_user_id INT                                 NOT NULL,
  ua_content LONGVARCHAR                         NOT NULL,
  ua_active  BOOLEAN DEFAULT TRUE                NOT NULL,
  ua_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);


-- Table of Comment

  DROP TABLE IF EXISTS comment;
  CREATE TABLE comment (

    cm_id          INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1) PRIMARY KEY,
    cm_question_id INT NOT NULL
  );


-- Table to Answer

  DROP TABLE IF EXISTS answer;
  CREATE TABLE answer (

    asw_id          INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1) PRIMARY KEY,
    asw_question_id INT                   NOT NULL,
    asw_votes       INT DEFAULT 0         NOT NULL,
    asw_accepted    BOOLEAN DEFAULT FALSE NOT NULL
  );


-- Table of Question

DROP TABLE IF EXISTS question;
CREATE TABLE question (

  qs_id        INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1) PRIMARY KEY,
  qs_title     VARCHAR(200)          NOT NULL,
  qs_votes     INT                   NOT NULL,
  qs_asw_count INT DEFAULT 0         NOT NULL
);


-- Table of Tag

DROP TABLE IF EXISTS tag;
CREATE TABLE tag (

  tag_id   INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1) PRIMARY KEY,
  tag_name VARCHAR(20) NOT NULL,
  tag_desc LONGVARCHAR NOT NULL,
  UNIQUE (tag_name)
);


-- Table reference with Question and Tags (many to many)

  DROP TABLE IF EXISTS question_tag;
  CREATE TABLE question_tag (

    qt_question_id INT NOT NULL,
    qt_tag_id      INT NOT NULL
  );


-- Define references

  ALTER TABLE user_activity
  ADD CONSTRAINT fk_ua_user_id FOREIGN KEY (ua_user_id) REFERENCES user (user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;


  ALTER TABLE comment
  ADD CONSTRAINT fk_cm_id FOREIGN KEY (cm_id) REFERENCES user_activity (ua_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;
  ALTER TABLE comment
  ADD CONSTRAINT fk_cm_question_id FOREIGN KEY (cm_question_id) REFERENCES question (qs_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;


  ALTER TABLE answer
  ADD CONSTRAINT fk_asw_id FOREIGN KEY (asw_id) REFERENCES user_activity (ua_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;
  ALTER TABLE answer
  ADD CONSTRAINT fk_asw_qs_id FOREIGN KEY (asw_question_id) REFERENCES question (qs_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;


  ALTER TABLE question_tag
  ADD CONSTRAINT fk_qt_question_id FOREIGN KEY (qt_question_id) REFERENCES question (qs_id);
  ALTER TABLE question_tag
  ADD CONSTRAINT fk_qt_tag_id FOREIGN KEY (qt_tag_id) REFERENCES tag (tag_id);


  ALTER TABLE question
  ADD CONSTRAINT fk_qs_id FOREIGN KEY (qs_id) REFERENCES user_activity (ua_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;


  ALTER TABLE user_badge
  ADD CONSTRAINT fk_ub_user_id FOREIGN KEY (ub_user_id) REFERENCES user (user_id);
  ALTER TABLE user_badge
  ADD CONSTRAINT fk_ub_badge_id FOREIGN KEY (ub_badge_id) REFERENCES badge (bdg_id);
