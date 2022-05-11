#!/bin/bash
# Generate player_classlevelstats.sql custom SQL with level81-100 support

tmpfile=$(mktemp /tmp/player_levelstats.sql80.XXX)
grep -Eo "\([0-9]+, 80, .*" ../../base/db_world/player_classlevelstats.sql > $tmpfile
data=$(../../../../src/tools/generate_stats.py $tmpfile 1)

template=$(cat << TT
ALTER TABLE player_classlevelstats MODIFY COLUMN basehp INT unsigned;
ALTER TABLE player_classlevelstats MODIFY COLUMN basemana INT unsigned; 

REPLACE INTO player_classlevelstats (class, level, basehp, basemana) VALUES
${data}
TT
)

echo "$template"
