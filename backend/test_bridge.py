import subprocess
import json
import re

class DB2Config:
    def __init__(self):
        self.database = "SAMPLE"
        self.user = "db2inst1"
        self.password = "1234"

def parse_db2_tabular_output(output):
    lines = [line.rstrip('\r\n') for line in output.split('\n')]
    sep_idx = -1
    for i, line in enumerate(lines):
        if re.match(r'^[-\s]+$', line) and '-' in line and len(line.strip()) > 2:
            sep_idx = i
            break
            
    if sep_idx <= 0:
        return [], []
        
    header_line = lines[sep_idx - 1]
    sep_line = lines[sep_idx]
    
    col_spans = []
    col_names = []
    matches = list(re.finditer(r'-+', sep_line))
    for m in matches:
        start, end = m.start(), m.end()
        col_spans.append((start, end))
        col_names.append(header_line[start:end].strip())
        
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

class DB2DirectCursor:
    def __init__(self, config: DB2Config):
        self.config = config
        self.description = None
        self.rowcount = -1
        self._rows = []
        self._idx = 0

    def _format_sql(self, sql: str, params: tuple) -> str:
        if not params:
            return sql.strip().rstrip(';')
        parts = sql.split('?')
        if len(parts) - 1 != len(params):
            return sql.strip().rstrip(';')
        out = []
        for i, val in enumerate(params):
            out.append(parts[i])
            if val is None:
                out.append("NULL")
            elif isinstance(val, (int, float)):
                out.append(str(val))
            elif isinstance(val, bool):
                out.append("1" if val else "0")
            elif isinstance(val, (dict, list)):
                s = json.dumps(val).replace("'", "''")
                out.append(f"'{s}'")
            else:
                s = str(val).replace("'", "''")
                out.append(f"'{s}'")
        out.append(parts[-1])
        return "".join(out).strip().rstrip(';')

    def execute(self, sql: str, params: tuple = ()):
        formatted_sql = self._format_sql(sql, params)
        cmd = [
            "wsl", "-u", "root", "podman", "exec", "db2server",
            "su", "-", "db2inst1", "-c",
            f"db2 connect to {self.config.database} user {self.config.user} using {self.config.password} > /dev/null; db2 \"{formatted_sql}\""
        ]
        res = subprocess.run(cmd, capture_output=True, text=True)
        if res.returncode != 0 and "DB20000I" not in res.stdout and "SQL0100W" not in res.stdout:
            if "23505" in res.stdout or "SQLSTATE=23505" in res.stdout:
                raise Exception(f"SQLSTATE=23505: {res.stdout}")
            if "SQL" in res.stdout:
                raise Exception(f"DB2 Error: {res.stdout}")

        col_names, rows_data = parse_db2_tabular_output(res.stdout)
        if col_names:
            self.description = [(col, None, None, None, None, None, None) for col in col_names]
            self._rows = [tuple(r.get(c) for c in col_names) for r in rows_data]
            self.rowcount = len(self._rows)
        else:
            self.description = None
            self._rows = []
            self.rowcount = 1 if "DB20000I" in res.stdout else 0
        self._idx = 0

    def fetchone(self):
        if self._rows and self._idx < len(self._rows):
            r = self._rows[self._idx]
            self._idx += 1
            return r
        return None

    def fetchall(self):
        if not self._rows:
            return []
        res = self._rows[self._idx:]
        self._idx = len(self._rows)
        return res

    def close(self):
        self._rows = []

class DB2DirectConnection:
    def __init__(self, config: DB2Config):
        self.config = config
        self._autocommit = True

    def cursor(self):
        return DB2DirectCursor(self.config)

    def commit(self):
        pass

    def rollback(self):
        pass

    def close(self):
        pass

    def set_autocommit(self, val: bool):
        self._autocommit = val

# Test
conn = DB2DirectConnection(DB2Config())
cur = conn.cursor()
cur.execute("SELECT bedId, ward, reconciledState FROM digital_twins WHERE ward = ?", ("ICU",))
print("Description:", cur.description)
rows = cur.fetchall()
print("Fetched rows:", rows)
cur.close()
