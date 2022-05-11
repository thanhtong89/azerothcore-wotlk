#!/bin/bash
# Generate pet_levelstats.sql custom SQL with level81-100 support

tmpfile=$(mktemp /tmp/pet_levelstats.sql80.XXX)
grep -Eo "\([0-9]+, 80, .*" ../../base/db_world/pet_levelstats.sql > $tmpfile
data=$(./generate_stats.py $tmpfile 1)

template=$(cat << TT
ALTER TABLE pet_levelstats MODIFY COLUMN  hp INT unsigned;
ALTER TABLE pet_levelstats MODIFY COLUMN  mana INT unsigned;
ALTER TABLE pet_levelstats MODIFY COLUMN  armor INT unsigned;
ALTER TABLE pet_levelstats MODIFY COLUMN  str INT unsigned;
ALTER TABLE pet_levelstats MODIFY COLUMN  agi INT unsigned;
ALTER TABLE pet_levelstats MODIFY COLUMN  sta INT unsigned;
ALTER TABLE pet_levelstats MODIFY COLUMN  inte INT unsigned;
ALTER TABLE pet_levelstats MODIFY COLUMN  spi INT unsigned;
ALTER TABLE pet_levelstats MODIFY COLUMN  min_dmg INT unsigned;
ALTER TABLE pet_levelstats MODIFY COLUMN  max_dmg INT unsigned;

REPLACE INTO pet_levelstats (creature_entry, level, hp, mana, armor, str, agi, sta, inte, spi, min_dmg, max_dmg) VALUES
${data}
TT
)

echo "$template"
