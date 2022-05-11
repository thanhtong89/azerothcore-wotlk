#!/usr/bin/env python3
import argparse
import re
import sys

maxLevel = 100
# expac -> (prevExpacMult, interLevelMult)
expacMultipliers = {
    81: (3, 1.2),
    85: (2, 1.2),
    86: (3, 1.2),
    90: (2, 1.10),
    91: (3, 1.10),
}

def parse_args():
    parser = argparse.ArgumentParser(description="Generates arbitrary extra stats beyond level cap")
    parser.add_argument("input", help="The file containing lines of level-80 stats for which we should generate extra stats")
    parser.add_argument("id_col_count", help="Number of columns making up the primary key (NOT counting the level column)")
    parser.add_argument("mults", help="""Custom multiplier dict. Format: LEVEL:LEVELMULT-SUBSEQUENTMULT. 
            E.g. 81:3-1.2 would mean at level 81, all stats get multiplied by 3, and then 1.2 thereafter until the next level specified.""")
    return parser.parse_args()

def processStatLine(line, idCols, mults):
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
        if level in mults:
            expacMult, levelMult = mults[level]
            mult = expacMult # applies once at expac's first level
        newStats = []
        for val in prevStats:
            newVal = int(float(val) * mult)
            newStats.append(str(newVal))
        newStatStr = ", ".join(newStats)
        lineRes.append(f"({lineID}, {level}, {newStatStr})")
        prevStats = newStats
    return lineRes

def parse_mult(multStr):
    res = {}
    pattern = re.compile("([0-9]+):([^-]+)-([^-]+)")
    for s in multStr.split(","):
        m = pattern.match(s)
        if m is None:
            raise ValueError(f"Invalid mult token: {s})")
        level, levelMult, seqMult = m.groups()
        res[int(level)] = (float(levelMult), float(seqMult)) 
    return res

if __name__ == "__main__":
    # file should contain:
    # id1, <id2>,..., 80 <stat1> <stat2> ...
    # args: filename idLength (number of cols making up the non-level primary key)
    args = parse_args()

    fname = args.input
    idCols = int(args.id_col_count)
    mults = parse_mult(args.mults)

    lines = []
    with open(fname, 'r') as fh:
        lines = fh.readlines()
    pattern = re.compile(".*\((.+)\)")
    result = []
    for line in lines:
        # strip all parens and trailing comma
        m = pattern.match(line)
        if m is None:
            continue
        parsedLine = m.group(1)
        result.extend(processStatLine(parsedLine, idCols, mults))
    for i, line in enumerate(result):
        term = ","
        if i == len(result) -1 :
            term = ";"
        print(f"{line}{term}")
