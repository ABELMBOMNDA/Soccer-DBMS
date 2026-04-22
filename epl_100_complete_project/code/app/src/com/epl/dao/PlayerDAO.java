package com.epl.dao;

import com.epl.db.DBConnection;
import com.epl.util.TableUtils;

import javax.swing.table.DefaultTableModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;

public class PlayerDAO {
    public DefaultTableModel getAllPlayers() throws Exception {
        String sql = """
                SELECT p.player_id,
                       CONCAT(p.first_name, ' ', p.last_name) AS player_name,
                       p.date_of_birth,
                       p.nationality,
                       pos.position_code,
                       p.squad_number,
                       p.preferred_foot,
                       c.club_name,
                       p.market_value
                FROM players p
                JOIN positions pos ON p.position_id = pos.position_id
                LEFT JOIN clubs c ON p.current_club_id = c.club_id
                ORDER BY p.last_name, p.first_name
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            return TableUtils.toTableModel(rs);
        }
    }

    public void insertPlayer(String firstName, String lastName, Date dateOfBirth, String nationality,
                             int positionId, int squadNumber, String preferredFoot, Integer clubId,
                             double marketValue) throws Exception {
        String sql = """
                INSERT INTO players
                (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, firstName);
            statement.setString(2, lastName);
            statement.setDate(3, dateOfBirth);
            statement.setString(4, nationality);
            statement.setInt(5, positionId);
            statement.setInt(6, squadNumber);
            statement.setString(7, preferredFoot);
            if (clubId == null) {
                statement.setNull(8, java.sql.Types.INTEGER);
            } else {
                statement.setInt(8, clubId);
            }
            statement.setDouble(9, marketValue);
            statement.executeUpdate();
        }
    }

    public void updatePlayer(int playerId, String firstName, String lastName, Date dateOfBirth, String nationality,
                             int positionId, int squadNumber, String preferredFoot, Integer clubId,
                             double marketValue) throws Exception {
        String sql = """
                UPDATE players
                SET first_name = ?, last_name = ?, date_of_birth = ?, nationality = ?, position_id = ?,
                    squad_number = ?, preferred_foot = ?, current_club_id = ?, market_value = ?
                WHERE player_id = ?
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, firstName);
            statement.setString(2, lastName);
            statement.setDate(3, dateOfBirth);
            statement.setString(4, nationality);
            statement.setInt(5, positionId);
            statement.setInt(6, squadNumber);
            statement.setString(7, preferredFoot);
            if (clubId == null) {
                statement.setNull(8, java.sql.Types.INTEGER);
            } else {
                statement.setInt(8, clubId);
            }
            statement.setDouble(9, marketValue);
            statement.setInt(10, playerId);
            statement.executeUpdate();
        }
    }

    public void deletePlayer(int playerId) throws Exception {
        String sql = "DELETE FROM players WHERE player_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, playerId);
            statement.executeUpdate();
        }
    }
}
