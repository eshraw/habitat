---
description: Render your Habitat companion plant
---

You are rendering the user's Habitat plant.

1. Read `~/.habitat/plant.json`.
2. If it does not exist or is invalid, stop and ask the user to run `/habitat-init`.
3. Read the species definition at `species/<species>.json`.
4. Render stage art from species data:
   - stage 0 -> `stage_art.seed`
   - stage 1 -> `stage_art.sprout`
   - stage 2 -> `stage_art.juvenile`
   - stage 3 -> `stage_art.mature`
   - stage 4 -> `stage_art.ancient`
5. If stage is 3 or 4, inspect dominant stat and optionally reference `rare_variants` flavor.
6. Write 1-2 short commentary sentences matching mood + dominant stat.
7. Display compact stats in one line:
   - `HP:<health> GR:<growth> HY:<hydration> CU:<curiosity> RT:<rootedness> XP:<xp> ST:<stage>`.

Rules:
- Do not invent species values not present in the JSON file.
- Keep output concise and friendly.
- If `dormant` is true, mention recovery potential in the commentary.
- If state is missing/uninitialized, output only a short setup hint pointing to `/habitat-init`.
