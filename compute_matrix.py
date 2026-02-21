#!/usr/bin/env python3
"""
Compute cosine similarity matrix for NBA teams.
This version uses only standard library + manual computation.
"""

import csv
import math

def dot_product(v1, v2):
    """Compute dot product of two vectors."""
    return sum(a * b for a, b in zip(v1, v2))

def magnitude(v):
    """Compute magnitude (L2 norm) of a vector."""
    return math.sqrt(sum(x * x for x in v))

def cosine_similarity(v1, v2):
    """Compute cosine similarity between two vectors."""
    dot = dot_product(v1, v2)
    mag1 = magnitude(v1)
    mag2 = magnitude(v2)
    if mag1 == 0 or mag2 == 0:
        return 0.0
    return dot / (mag1 * mag2)

# Read CSV file
csv_path = r'C:\Users\maxim\Downloads\sportsref_download(Worksheet).csv'
teams = []
stats_list = []

with open(csv_path, 'r', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        if row['Team'] == 'League Average':
            continue
        teams.append(row['Team'])
        # Extract all stat columns (all except 'Team')
        stats = [float(row[col]) for col in reader.fieldnames if col != 'Team']
        stats_list.append(stats)

# Compute similarity matrix
n = len(teams)
similarity_matrix = [[0.0] * n for _ in range(n)]

for i in range(n):
    for j in range(n):
        similarity_matrix[i][j] = cosine_similarity(stats_list[i], stats_list[j])

# Write output CSV
output_path = r'C:\Users\maxim\Downloads\nba_team_similarity_matrix.csv'
with open(output_path, 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    # Write header
    writer.writerow(['Team'] + teams)
    # Write rows
    for i, team in enumerate(teams):
        row = [team] + [f'{similarity_matrix[i][j]:.6f}' for j in range(n)]
        writer.writerow(row)

print(f"Computed {n}x{n} similarity matrix")
print(f"Output saved to: {output_path}")
print(f"\nMatrix preview (first 5x5):")
print("Team", end="")
for j in range(min(5, n)):
    print(f"\t{teams[j][:15]}", end="")
print()
for i in range(min(5, n)):
    print(teams[i][:20], end="")
    for j in range(min(5, n)):
        print(f"\t{similarity_matrix[i][j]:.4f}", end="")
    print()
