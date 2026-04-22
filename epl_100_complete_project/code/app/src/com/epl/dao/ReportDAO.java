package com.epl.dao;

import com.epl.db.DBConnection;
import com.epl.util.TableUtils;

import javax.swing.table.DefaultTableModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ReportDAO {
    public DefaultTableModel getStandings(int seasonId) throws Exception {
        String sql = """
                SELECT st.position_no, c.club_name, st.played, st.wins, st.draws, st.losses,
                       st.goals_for, st.goals_against, st.goal_difference, st.points
                FROM standings st
                JOIN clubs c ON st.club_id = c.club_id
                WHERE st.season_id = ?
                ORDER BY st.position_no
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, seasonId);
            try (ResultSet rs = statement.executeQuery()) {
                return TableUtils.toTableModel(rs);
            }
        }
    }

    public DefaultTableModel getTopScorers(int seasonId) throws Exception {
        String sql = """
                SELECT CONCAT(p.first_name, ' ', p.last_name) AS player_name,
                       c.club_name,
                       COUNT(*) AS goals
                FROM match_events me
                JOIN fixtures f ON me.fixture_id = f.fixture_id
                JOIN players p ON me.player_id = p.player_id
                JOIN clubs c ON me.club_id = c.club_id
                WHERE f.season_id = ?
                  AND me.event_type IN ('GOAL', 'PENALTY_GOAL')
                GROUP BY p.player_id, player_name, c.club_name
                ORDER BY goals DESC, player_name
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, seasonId);
            try (ResultSet rs = statement.executeQuery()) {
                return TableUtils.toTableModel(rs);
            }
        }
    }

    public DefaultTableModel getFixturesByMatchweek(int seasonId, int matchweek) throws Exception {
        String sql = """
                SELECT DATE_FORMAT(f.match_date, '%Y-%m-%d %H:%i') AS match_date,
                       hc.club_name AS home_club,
                       ac.club_name AS away_club,
                       st.stadium_name,
                       f.status,
                       CONCAT(f.home_score, ' - ', f.away_score) AS score
                FROM fixtures f
                JOIN clubs hc ON f.home_club_id = hc.club_id
                JOIN clubs ac ON f.away_club_id = ac.club_id
                JOIN stadiums st ON f.stadium_id = st.stadium_id
                WHERE f.season_id = ? AND f.matchweek = ?
                ORDER BY f.match_date
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, seasonId);
            statement.setInt(2, matchweek);
            try (ResultSet rs = statement.executeQuery()) {
                return TableUtils.toTableModel(rs);
            }
        }
    }

    public DefaultTableModel getTransfersByClub(int clubId) throws Exception {
        String sql = """
                SELECT CONCAT(p.first_name, ' ', p.last_name) AS player_name,
                       COALESCE(fc.club_name, 'Free Agent') AS from_club,
                       tc.club_name AS to_club,
                       t.transfer_date,
                       t.transfer_fee,
                       t.transfer_type,
                       t.status
                FROM transfers t
                JOIN players p ON t.player_id = p.player_id
                LEFT JOIN clubs fc ON t.from_club_id = fc.club_id
                JOIN clubs tc ON t.to_club_id = tc.club_id
                WHERE t.to_club_id = ? OR t.from_club_id = ?
                ORDER BY t.transfer_date DESC
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, clubId);
            statement.setInt(2, clubId);
            try (ResultSet rs = statement.executeQuery()) {
                return TableUtils.toTableModel(rs);
            }
        }
    }

    public int countRows(String tableName) throws Exception {
        if (!tableName.matches("[A-Za-z_]+")) {
            throw new IllegalArgumentException("Invalid table name.");
        }
        String sql = "SELECT COUNT(*) FROM " + tableName;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }
}
