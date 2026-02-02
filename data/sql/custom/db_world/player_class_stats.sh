#!/bin/bash
# Generate player_class_stats.sql custom SQL with level81-100 support

basefile=../../base/db_world/player_class_stats.sql

# --- Pass 1: BaseHP, BaseMana (using old classlevelstats multipliers) ---
hp_mults="81:3-1.2,85:2-1,86:3-1.2,90:2-1,91:2-1.1,100:1.6-1"
hp_tmpfile=$(mktemp /tmp/player_class_stats_hp.sql80.XXX)
# Extract (Class, 80, BaseHP, BaseMana) from rows like (1,80,8121,0,174,113,159,36,59)
grep -Eo "\([0-9]+,80,[^)]*\)" "$basefile" | sed -E 's/\(([0-9]+),80,([0-9]+),([0-9]+),(.*)\)/(\1, 80, \2, \3)/' > "$hp_tmpfile"
hp_data=$(./generate_stats.py "$hp_tmpfile" 1 "${hp_mults}" | sed '$ s/;$//')
rm -f "$hp_tmpfile"

# --- Pass 2: Strength, Agility, Stamina, Intellect, Spirit ---
attr_mults="81:3-1.2,85:4-1,86:3-1.2,90:4-1,91:2-1.1,100:1.6-1"
attr_tmpfile=$(mktemp /tmp/player_class_stats_attr.sql80.XXX)
# Extract (Class, 80, Str, Agi, Sta, Int, Spi) from rows like (1,80,8121,0,174,113,159,36,59)
grep -Eo "\([0-9]+,80,[^)]*\)" "$basefile" | sed -E 's/\(([0-9]+),80,[0-9]+,[0-9]+,([0-9]+),([0-9]+),([0-9]+),([0-9]+),([0-9]+)\)/(\1, 80, \2, \3, \4, \5, \6)/' > "$attr_tmpfile"
attr_data=$(./generate_stats.py "$attr_tmpfile" 1 "${attr_mults}" | sed '$ s/;$//')
rm -f "$attr_tmpfile"

template=$(cat << TT
ALTER TABLE player_class_stats MODIFY COLUMN BaseHP INT unsigned;
ALTER TABLE player_class_stats MODIFY COLUMN BaseMana INT unsigned;
ALTER TABLE player_class_stats MODIFY COLUMN Strength INT unsigned;
ALTER TABLE player_class_stats MODIFY COLUMN Agility INT unsigned;
ALTER TABLE player_class_stats MODIFY COLUMN Stamina INT unsigned;
ALTER TABLE player_class_stats MODIFY COLUMN Intellect INT unsigned;
ALTER TABLE player_class_stats MODIFY COLUMN Spirit INT unsigned;

INSERT INTO player_class_stats (Class, Level, BaseHP, BaseMana) VALUES
${hp_data}
ON DUPLICATE KEY UPDATE BaseHP=VALUES(BaseHP), BaseMana=VALUES(BaseMana);

INSERT INTO player_class_stats (Class, Level, Strength, Agility, Stamina, Intellect, Spirit) VALUES
${attr_data}
ON DUPLICATE KEY UPDATE Strength=VALUES(Strength), Agility=VALUES(Agility), Stamina=VALUES(Stamina), Intellect=VALUES(Intellect), Spirit=VALUES(Spirit)
TT
)

echo "$template"
