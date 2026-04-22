package com.epl.dao;

import com.epl.db.DBConnection;
import com.epl.util.TableUtils;

import javax.swing.table.DefaultTableModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

public class FixtureDAO {
    public DefaultTableModel getAllFixtures() throws Exception {
        String sql = """
                SELECT f.fixture_id, s.season_name, f.matchweek,
                       DATE_FORMAT(f.match_date, '%Y-%m-%d %H:%i') AS match_date,
                       hc.club_name AS home_club,
                       ac.club_name AS away_club,
                       st.stadium_name,
                       CONCAT(f.home_score, ' - ', f.away_score) AS score,
                       f.status,
                       f.attendance
                FROM fixtures f
                JOIN seasons s ON f.season_id = s.season_id
                JOIN clubs hc ON f.home_club_id = hc.club_id
                JOIN clubs ac ON f.away_club_id = ac.club_id
                JOIN stadiums st ON f.stadium_id = st.stadium_id
                ORDER BY f.match_date DESC
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            return TableUtils.toTableModel(rs);
        }
    }

    public void insertFixture(int seasonId, int matchweek, Timestamp matchDate, int stadiumId,
                              int homeClubId, int awayClubId, int homeScore, int awayScore,
                              String status, int attendance) throws Exception {
        String sql = """
                INSERT INTO fixtures
                (season_id, matchweek, match_date, stadium_id, home_club_id, away_club_id, home_score, away_score, status, attendance)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, seasonId);
            statement.setInt(2, matchweek);
            statement.setTimestamp(3, matchDate);
            statement.setInt(4, stadiumId);
            statement.setInt(5, homeClubId);
            statement.setInt(6, awayClubId);
            statement.setInt(7, homeScore);
            statement.setInt(8, awayScore);
            statement.setString(9, status);
            statement.setInt(10, attendance);
            statement.executeUpdate();
        }
    }

    public void updateFixture(int fixtureId, int seasonId, int matchweek, Timestamp matchDate, int stadiumId,
                              int homeClubId, int awayClubId, int homeScore, int awayScore,
                              String status, int attendance) throws Exception {
        String sql = """
                UPDATE fixtures
                SET season_id = ?, matchweek = ?, match_date = ?, stadium_id = ?, home_club_id = ?, away_club_id = ?,
                    home_score = ?, away_score = ?, status = ?, attendance = ?
                WHERE fixture_id = ?
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, seasonId);
            statement.setInt(2, matchweek);
            statement.setTimestamp(3, matchDate);
            statement.setInt(4, stadiumId);
            statement.setInt(5, homeClubId);
            statement.setInt(6, awayClubId);
            statement.setInt(7, homeScore);
            statement.setInt(8, awayScore);
            statement.setString(9, status);
            statement.setInt(10, attendance);
            statement.setInt(11, fixtureId);
            statement.executeUpdate();
        }
    }

    public void deleteFixture(int fixtureId) throws Exception {
        String sql = "DELETE FROM fixtures WHERE fixture_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, fixtureId);
            statement.executeUpdate();
        }
    }
}
