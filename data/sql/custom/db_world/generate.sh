#!/bin/bash

for fname in pet_levelstats player_class_stats; do
	echo "Generating ${fname}..."
	./${fname}.sh > ${fname}.sql
done
