# EPL Project Integration Addendum

## Purpose
This addendum closes the final gap between the original project documentation and the finished technical package.

## Final integrated state
The project is now fully connected across all major deliverables:
- the database schema creates the operational tables and the `official_registered_squads` table
- the sample data script loads the demonstration data and the official current squad snapshot
- the Java Swing application includes a new **Official Squads** tab
- the dashboard now reports the official squad-entry count and latest snapshot date
- the SQL report pack now includes official squad summary queries
- the project zip bundles the code, documentation, presentation deck, ERD, schema, flyer, and current squad dataset in one structure

## Important design choice
The official current squads are stored in a dedicated table instead of forcing them into the `players` table. This was done intentionally because the official squad-list publication provides registered player names and home-grown status, but does not provide every operational field used by the `players` entity, such as date of birth, position, preferred foot, and market value.

## Application integration
A new read-only module was added:
- `OfficialSquadDAO.java`
- `OfficialSquadPanel.java`

This module allows users to:
- load the official registered squad by season
- filter by club
- search by player name
- view senior-squad summary counts by club
- view home-grown player reports

## Database integration
The final SQL flow is:
1. `01_schema.sql`
2. `02_sample_data.sql`
3. `03_reports.sql`

Optional refresh script:
4. `04_official_current_registered_squads_2025_26.sql`

## Build completeness
The Java application source is now build-complete. Missing shared classes were added:
- `ComboItem.java`
- `TableUtils.java`
- `UIUtils.java`

Build and run scripts were also corrected so the project can be compiled into a JAR from the included source tree.

## What still requires the user's environment
The package is complete, but it still needs the user's local environment to run:
- MySQL Server
- MySQL Workbench
- Java JDK
- MySQL Connector/J placed inside `code/app/lib/`
- valid database credentials in `code/app/dist/db.properties`

## Recommended presentation wording
You can now accurately say that the project includes:
- a Java Swing front end
- a MySQL relational database
- JDBC connectivity
- operational EPL entity management
- official registered squad integration based on the latest official season snapshot included in the package
