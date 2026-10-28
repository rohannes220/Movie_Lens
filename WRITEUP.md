## Step 3 – Load the data

### 3a. Predictions (written before running load.py)




| Table        | Predicted | Actual | Difference explained |
|--------------|-----------|--------|----------------------|
| genres       | 19        |        |                      |
| users        | 943       |        |                      |
| movies       | 1,682     |        |                      |
| movie_genres | 2,893     |        |                      |
| ratings      | 100,000   |        |                      |
| rejected     | 0         |        |                      |

Expected refusals: none. Every rating is 1–5, IDs are in range, gender is M/F,
all occupations are on the list, and movie 267's blank release date is allowed
because release_date can be NULL.
