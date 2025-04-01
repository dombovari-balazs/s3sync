import json
from pathlib import Path

def load_event_from_file(filename: str) -> dict:
    path = Path(__file__).parent / "files" / filename
    with path.open() as f:
        return json.load(f)

