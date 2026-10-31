#imports
from pathlib import Path

import gmsh
import pandas as pd

SCRIPT_DIR = Path(__file__).resolve().parent
GEO_FILE = SCRIPT_DIR.parent / "Meshes" / "Blanket_OneRow.geo"

# Point tags created by the "Getting points for 1d channels" block at the
# bottom of Blanket_OneRow.geo. Each pipe has one "anchor" point plus two
# runs of 6 points (each made with `newp` inside a For loop) stepping up/down
# in z from the anchor. The tags are traced by hand from that block's own
# `newp`/`Point{45}`/`Point{58}`/`Point{71}` references, so they only stay
# valid as long as nothing above that section of the .geo file changes.
PIPES = {
    "Top_Pipe": {"anchor": 45, "down": range(46, 52), "up": range(52, 58)},
    "Bottom_Pipe": {"anchor": 58, "down": range(59, 65), "up": range(65, 71)},
    "Back_Pipe": {"anchor": 71, "down": range(78, 84), "up": range(72, 78)},
}

gmsh.initialize()
gmsh.open(str(GEO_FILE))  # runs the .geo script and builds all of its points

for name, tags in PIPES.items():
    ordered_tags = [*reversed(list(tags["down"])), tags["anchor"], *tags["up"]]
    coords = [gmsh.model.getValue(0, tag, []) for tag in ordered_tags]
    df = pd.DataFrame(coords, columns=["x", "y", "z"])
    df.to_csv(SCRIPT_DIR / f"{name}.csv", index=False)
    print(f"Wrote {name}.csv ({len(df)} points)")

gmsh.finalize()
