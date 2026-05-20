-- Genre Bridge Table

CREATE TABLE clean.content_genres AS
SELECT
	content_id,
	TRIM(UNNEST(string_to_array(listed_in, ','))) AS genre_name
FROM clean.content;


