# Bulk Renamer

A Bash script that renames all files in a folderin one go, with a dry-run mode to preview changes before applying them.

## Usage

```bash
bash renamer.sh -m <mode> [-p text]
```

## Modes

| Mode | Effect | Example |
|------|--------|---------|
| `lower` | Lowercase the name | `Photo.JPG` -> `photo.jpg` |
| `spaces` | Replaces spaces with `_` |  `my file.txt` -> `my_file.txt` |
| `prefix` | Add text to the start (needs `-p`) | `notes.txt` -> `2026_notes.txt` |
| `number` | Number files, keep extension | `a.jpg` -> `001.jpg` |

## Examples 

```bash
bash renamer.sh -m lower -d  photos        # preview only
bash renamer.sh -m spaces photos           # apply
bash renamer.sh -m prefix -p 2026_photos
```

## Requirements

Bash (Git Bash on Windows) 
