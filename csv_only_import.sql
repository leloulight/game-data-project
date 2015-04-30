
CREATE TEMP TABLE tmp_table AS SELECT * FROM game_data;

COPY tmp_table FROM :csv CSV HEADER;

SELECT count(*) FROM tmp_table;  -- Just to be sure

TRUNCATE game_data;

INSERT INTO game_data
    SELECT DISTINCT ON (name) * FROM tmp_table
    ORDER BY name;

SELECT count(*) FROM game_data;  -- Paranoid again