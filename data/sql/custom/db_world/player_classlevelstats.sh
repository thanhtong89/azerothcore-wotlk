#!/bin/bash
# Generate player_classlevelstats.sql custom SQL with level81-100 support

mults="81:3-1.2,85:2-1,86:3-1.2,90:2-1,91:2-1.1,100:1.6-1"
tmpfile=$(mktemp /tmp/player_levelstats.sql80.XXX)
grep -Eo "\([0-9]+, 80, .*" ../../base/db_world/player_classlevelstats.sql > $tmpfile
data=$(./generate_stats.py $tmpfile 1 "${mults}")

template=$(cat << TT
ALTER TABLE player_classlevelstats MODIFY COLUMN basehp INT unsigned;
ALTER TABLE player_classlevelstats MODIFY COLUMN basemana INT unsigned; 

REPLACE INTO player_classlevelstats (class, level, basehp, basemana) VALUES
${data}
TT
)

echo "$template"
