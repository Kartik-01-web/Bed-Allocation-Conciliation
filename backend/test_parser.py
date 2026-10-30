import re

def parse_db2_output(output):
    """
    Parses standard DB2 CLI tabular output into column descriptions and list of tuples/dicts.
    """
    lines = [line.rstrip('\r\n') for line in output.split('\n')]
    # Find separator line of dashes: e.g. "---------- --------------------"
    sep_idx = -1
    for i, line in enumerate(lines):
        if re.match(r'^[-\s]+$', line) and '-' in line and len(line.strip()) > 2:
            sep_idx = i
            break
            
    if sep_idx == -1 or sep_idx == 0:
        return [], []
        
    header_line = lines[sep_idx - 1]
    sep_line = lines[sep_idx]
    
    # Determine column slices based on dash groups
    col_spans = []
    col_names = []
    
    matches = list(re.finditer(r'-+', sep_line))
    for m in matches:
        start, end = m.start(), m.end()
        col_spans.append((start, end))
        name = header_line[start:end].strip()
        col_names.append(name)
        
    rows = []
    for line in lines[sep_idx + 1:]:
        if not line.strip():
            continue
        if "record(s) selected" in line or "DB20000I" in line:
            break
        row_vals = []
        for start, end in col_spans:
            val = line[start:end].strip() if start < len(line) else ""
            if val == "-":
                val = None
            row_vals.append(val)
        rows.append(dict(zip(col_names, row_vals)))
        
    return col_names, rows

sample = """
BEDID      WARD                 RECONCILEDSTATE               
---------- -------------------- ------------------------------
B01        ICU                  OCCUPIED                      
B02        EMERGENCY            OCCUPIED                      
B03        GENERAL              OCCUPIED                      

  3 record(s) selected.
"""

cols, rows = parse_db2_output(sample)
print("Parsed cols:", cols)
print("Parsed rows:", rows)
