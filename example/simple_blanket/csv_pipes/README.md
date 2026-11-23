# csv_pipes

CSV files consumed by the `FilePipe1Phase` components in `simple_channel_plate.i`,
`simple_channel_plate_bottom.i`, and `simple_channel_backwall.i` (and, through
those, `simple_blanket_heat_transfer.i`): `Top_Pipe.csv`, `Bottom_Pipe.csv`, and
`Back_Pipe.csv`.

## CSV format

`FilePipe1Phase` (`src/components/FilePipe1Phase.C`) builds a 1D pipe mesh
directly from these files, so each one must be a 3-column, headered CSV
(`x, y, z`) listing, in order, the nodes along a channel's centerline.

## Generating the CSVs

These three CSVs are generated, not hand-authored. Run:

```
python3 Pipe_to_csv_gen.py
```

from this directory (ensure that `gmsh` and `pandas` are available in the python interpreter path).
The CSVs are gitignored (`*.csv`), so this script must be re-run after cloning, and again any time
`../Meshes/Blanket_OneRow.geo` changes.

## Where the coordinates come from

`../Meshes/Blanket_OneRow.geo` has a section near the bottom, "Getting points
for 1d channels", written in Gmsh's native scripting language. For each of the
three channels it translates an existing point to get a centerline anchor,
then walks outward from that anchor in two `For` loops (stepping +/- in `z`)
to build the rest of the centerline, `Printf`-ing each point's coordinates as
it goes.

Historically, Gmsh was run, the `Printf` output was copied out of the log by
hand, and it was pasted into Excel. `Pipe_to_csv_gen.py` automates that step:
it opens the `.geo` file with the gmsh Python API (which executes that scripting
section and actually builds the points), then queries the resulting point coordinates
directly via `gmsh.model.getValue()` instead of scraping log text.

## A note on the point tags

Each point created with Gmsh's `newp` gets the next unused tag, so the tags
used in this script (see the `PIPES` dict) were traced by hand from the
`.geo` file's own `Point{45}`/`Point{58}`/`Point{71}` references. This mapping
is only valid as long as nothing above that section of `Blanket_OneRow.geo`
changes -- inserting or removing points earlier in the file will shift every
tag after it, and the `PIPES` dict in `Pipe_to_csv_gen.py` will need to be
re-traced to match.
