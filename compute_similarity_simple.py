"""
NBA Team Similarity Calculator (Simple Version)
Computes cosine similarity between all pairs of NBA teams based on their stats.
Uses only numpy for cosine similarity calculation (no sklearn dependency).
"""

try:
    import pandas as pd  # type: ignore[reportMissingImports]
    import numpy as np  # type: ignore[reportMissingImports]
except ImportError as e:
    print("Error: Required packages not found.")
    print("Please install them using:")
    print("  pip install pandas numpy")
    print(f"\nMissing package: {e}")
    exit(1)

def cosine_similarity_matrix(X):
    """
    Compute cosine similarity matrix manually using numpy.
    X: numpy array of shape (n_samples, n_features)
    Returns: numpy array of shape (n_samples, n_samples)
    """
    # Normalize each row (team) to unit length
    X_norm = X / np.linalg.norm(X, axis=1, keepdims=True)
    # Compute pairwise cosine similarity: dot product of normalized vectors
    similarity = np.dot(X_norm, X_norm.T)
    return similarity

# Read the CSV file
csv_path = r'C:\Users\maxim\Downloads\sportsref_download(Worksheet).csv'
try:
    df = pd.read_csv(csv_path)
except FileNotFoundError:
    print(f"Error: Could not find CSV file at {csv_path}")
    exit(1)

# Filter out "League Average" row if it exists
df = df[df['Team'] != 'League Average'].reset_index(drop=True)

# Extract team names
teams = df['Team'].values

# Extract stats (all columns except 'Team')
stats = df.drop('Team', axis=1).values

# Compute cosine similarity matrix
similarity_matrix = cosine_similarity_matrix(stats)

# Create a DataFrame with team names as both index and columns for better readability
similarity_df = pd.DataFrame(similarity_matrix, index=teams, columns=teams)

# Round to 4 decimal places for readability
similarity_df = similarity_df.round(4)

# Display the matrix
print("Cosine Similarity Matrix (30×30):")
print("=" * 80)
print(similarity_df.to_string())

# Save to CSV
output_file = r'C:\Users\maxim\Downloads\nba_team_similarity_matrix.csv'
similarity_df.to_csv(output_file)
print(f"\n\nMatrix saved to: {output_file}")

# Print some statistics
print("\n" + "=" * 80)
print("Statistics:")
print(f"Number of teams: {len(teams)}")
print(f"Matrix shape: {similarity_matrix.shape}")
print(f"Min similarity: {similarity_matrix.min():.4f}")
print(f"Max similarity: {similarity_matrix.max():.4f}")
print(f"Mean similarity: {similarity_matrix.mean():.4f}")
