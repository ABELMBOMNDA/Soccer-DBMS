# EPL DBMS Project — Final Integrated Package

This folder is the fully connected final deliverable for the English Premier League database project.

## What is now fully connected
- MySQL schema and sample data scripts
- Java Swing desktop application
- JDBC database connectivity
- CRUD screens for clubs, players, fixtures, and transfers
- SQL reports
- Official Premier League registered squad snapshot integrated into the database and the application UI
- Report, guideline, reference manual, tutorial manual, flyer, ERD, schema diagram, and presentation deck

## Main folders
- `code/database/` — SQL scripts and current official squad CSV
- `code/app/` — Java Swing source code, build scripts, and runnable JAR
- `documentation/` — report, manuals, and guideline
- `slides/` — final presentation deck and ERD/schema exports
- `flyer/` — application flyer

## Run order
1. Run `code/database/01_schema.sql` in MySQL Workbench.
2. Run `code/database/02_sample_data.sql` in MySQL Workbench.
3. Run `code/database/03_reports.sql` to test example report queries.
4. Optional: run `code/database/04_official_current_registered_squads_2025_26.sql` only if you want to refresh the official squad table separately.
5. Edit `code/app/dist/db.properties` after building the Java app.
6. On macOS/Linux, open Terminal inside `code/app/` and run:
   - `bash build.sh`
   - `bash run.sh`

## App tabs
- Dashboard
- Clubs
- Players
- Fixtures
- Transfers
- Official Squads
- Reports

## Official squad source
The official current squads included in this project are based on the Premier League's official 2025/26 updated squad-list publication dated 5 February 2026, which followed the January 2026 transfer window.

See the included integration addendum for the final architecture summary.
