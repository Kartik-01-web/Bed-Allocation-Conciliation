import subprocess
import sys

def run_db2_cmd(sql):
    cmd = [
        "wsl", "-u", "root", "podman", "exec", "db2server",
        "su", "-", "db2inst1", "-c",
        f"db2 connect to SAMPLE user db2inst1 using 1234 > /dev/null; db2 \"{sql}\""
    ]
    res = subprocess.run(cmd, capture_output=True, text=True)
    return res.stdout

def main():
    print("=== IBM DB2 LIVE CRUD & DATA MODELING TEST ===")
    
    # 1. CREATE (Insert a test bed twin)
    print("\n1. CREATE OPERATION:")
    out = run_db2_cmd("INSERT INTO digital_twins (bedId, ward, adminState, sourceAState, sourceBState, reconciledState, confidence, needsHumanReview, createdAt, updatedAt) VALUES ('B99', 'ICU', 'AVAILABLE', 'AVAILABLE', 'AVAILABLE', 'CONFIRMED_AVAILABLE', 'HIGH', 0, 1788640000.0, 1788640000.0)")
    print(out.strip())

    # 2. READ (Query the inserted bed)
    print("\n2. READ OPERATION:")
    out = run_db2_cmd("SELECT bedId, ward, reconciledState, confidence FROM digital_twins WHERE bedId = 'B99'")
    print(out.strip())

    # 3. UPDATE (Update the bed state to OCCUPIED)
    print("\n3. UPDATE OPERATION:")
    out = run_db2_cmd("UPDATE digital_twins SET reconciledState = 'OCCUPIED', activePatientId = 'P999' WHERE bedId = 'B99'")
    print(out.strip())
    
    out = run_db2_cmd("SELECT bedId, ward, reconciledState, activePatientId FROM digital_twins WHERE bedId = 'B99'")
    print(out.strip())

    # 4. DELETE (Remove the test bed)
    print("\n4. DELETE OPERATION:")
    out = run_db2_cmd("DELETE FROM digital_twins WHERE bedId = 'B99'")
    print(out.strip())

    out = run_db2_cmd("SELECT COUNT(1) AS count_after_delete FROM digital_twins WHERE bedId = 'B99'")
    print(out.strip())

    # 5. DATA MODELING ANALYTICAL QUERY
    print("\n5. ADVANCED DATA MODELING QUERY: WARD OCCUPANCY & UTILIZATION RATE")
    query = """
    SELECT
        ward,
        COUNT(1) AS total_beds,
        SUM(CASE WHEN reconciledState = 'OCCUPIED' THEN 1 ELSE 0 END) AS occupied,
        SUM(CASE WHEN reconciledState = 'CONFIRMED_AVAILABLE' THEN 1 ELSE 0 END) AS available,
        ROUND(CAST(SUM(CASE WHEN reconciledState = 'OCCUPIED' THEN 1 ELSE 0 END) AS DOUBLE) / COUNT(1) * 100, 2) AS occupancy_pct
    FROM digital_twins
    GROUP BY ward
    ORDER BY ward ASC
    """
    out = run_db2_cmd(query.replace("\n", " "))
    print(out.strip())

if __name__ == "__main__":
    main()
