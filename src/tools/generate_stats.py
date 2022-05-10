#!/usr/bin/env python3
import re
import sys

maxLevel = 100
# expac -> (prevExpacMult, interLevelMult)
expacMultipliers = {
    81: (3, 1.15),
    86: (3, 1.15),
    91: (3, 1.10),
}

def processStatLine(line, idCols):
    tokens = line.split(", ")
    if len(tokens) < idCols+2:
        raise ValueError("Insufficient tokens")
    lineID = ", ".join(tokens[:idCols])
    if tokens[idCols] != "80":
        raise ValueError(f"line {line}: second arg must be 80")

    level = int(tokens[idCols])
    prevStats = []
    for statToken in tokens[idCols+1:]:
        try:
            val = int(statToken)
            prevStats.append(val)
        except ValueError:
            print(f"line {line}: token {statToken} invalid")
            raise
        
    lineRes = []
    # generate from level+1 - maxLevel stats.
    levelMult = 1.1
    while level < maxLevel:
        level += 1
        mult = levelMult
        if level in expacMultipliers:
            expacMult, levelMult = expacMultipliers[level]
            mult = expacMult # applies once at expac's first level
        newStats = []
        for val in prevStats:
            newVal = int(float(val) * mult)
            newStats.append(str(newVal))
        newStatStr = ", ".join(newStats)
        lineRes.append(f"({lineID}, {level}, {newStatStr})")
        prevStats = newStats
    return lineRes

if __name__ == "__main__":
    # file should contain:
    # id1, <id2>,..., 80 <stat1> <stat2> ...
    # args: filename idLength (number of cols making up the non-level primary key)
    fname = sys.argv[1]
    idCols = int(sys.argv[2])
    lines = []
    with open(fname, 'r') as fh:
        lines = fh.readlines()
    pattern = re.compile(".*\((.+)\)")
    result = []
    for line in lines:
        print(f"--- processing line {line} ---")
        # strip all parens and trailing comma
        m = pattern.match(line)
        if m is None:
            print(f"Skipping line f{line}")
            continue
        parsedLine = m.group(1)
        result.extend(processStatLine(parsedLine, idCols))
    for i, line in enumerate(result):
        term = ","
        if i == len(result) -1 :
            term = ";"
        print(f"{line}{term}")
