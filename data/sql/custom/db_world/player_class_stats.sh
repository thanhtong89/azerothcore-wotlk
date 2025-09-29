#!/bin/bash
# Generate player_class_stats.sql custom SQL with level81-100 support

mults="81:3-1.2,85:4-1,86:3-1.2,90:4-1,91:2-1.1,100:1.6-1"
tmpfile=$(mktemp /tmp/player_class_stats.sql80.XXX)
grep -Eo "\([0-9]+, 80, .*" ../../base/db_world/player_class_stats.sql > $tmpfile
data=$(./generate_stats.py $tmpfile 1 "${mults}")

template=$(cat << TT
ALTER TABLE player_class_stats MODIFY COLUMN Strength INT unsigned;
ALTER TABLE player_class_stats MODIFY COLUMN Agility INT unsigned;
ALTER TABLE player_class_stats MODIFY COLUMN Stamina INT unsigned;
ALTER TABLE player_class_stats MODIFY COLUMN Intellect INT unsigned;
ALTER TABLE player_class_stats MODIFY COLUMN Spirit INT unsigned;

REPLACE INTO player_class_stats (Class, Level, Strength, Agility, Stamina, Intellect, Spirit) VALUES
${data}
TT
)

echo "$template"
