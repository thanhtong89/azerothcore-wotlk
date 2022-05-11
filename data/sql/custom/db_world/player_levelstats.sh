#!/bin/bash
# Generate player_levelstats.sql custom SQL with level81-100 support

mults="81:3-1.2,85:2-1,86:3-1.2,90:2-1,91:3-1.2"
tmpfile=$(mktemp /tmp/player_levelstats.sql80.XXX)
grep -Eo "\([0-9]+, [0-9]+, 80, .*" ../../base/db_world/player_levelstats.sql > $tmpfile
data=$(./generate_stats.py $tmpfile 2 "${mults}")

template=$(cat << TT
ALTER TABLE player_levelstats MODIFY COLUMN str INT unsigned;
ALTER TABLE player_levelstats MODIFY COLUMN agi INT unsigned;
ALTER TABLE player_levelstats MODIFY COLUMN sta INT unsigned;
ALTER TABLE player_levelstats MODIFY COLUMN inte INT unsigned;
ALTER TABLE player_levelstats MODIFY COLUMN spi INT unsigned;

REPLACE INTO player_levelstats (race, class, level, str, agi, sta, inte, spi) VALUES
${data}
TT
)

echo "$template"
