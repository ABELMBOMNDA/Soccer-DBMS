package com.epl.dao;

import com.epl.db.DBConnection;
import com.epl.util.TableUtils;

import javax.swing.table.DefaultTableModel;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TransferDAO {
    public DefaultTableModel getAllTransfers() throws Exception {
        String sql = """
                SELECT t.transfer_id,
                       CONCAT(p.first_name, ' ', p.last_name) AS player_name,
                       s.season_name,
                       COALESCE(fc.club_name, 'Free Agent') AS from_club,
                       tc.club_name AS to_club,
                       t.transfer_date,
                       t.transfer_fee,
                       t.transfer_type,
                       t.status
                FROM transfers t
                JOIN players p ON t.player_id = p.player_id
                JOIN seasons s ON t.season_id = s.season_id
                LEFT JOIN clubs fc ON t.from_club_id = fc.club_id
                JOIN clubs tc ON t.to_club_id = tc.club_id
                ORDER BY t.transfer_date DESC
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            return TableUtils.toTableModel(rs);
        }
    }

    public void insertTransfer(int playerId, int seasonId, Integer fromClubId, int toClubId,
                               Date transferDate, double transferFee, String transferType,
                               String status) throws Exception {
        String sql = """
                INSERT INTO transfers
                (player_id, season_id, from_club_id, to_club_id, transfer_date, transfer_fee, transfer_type, status)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, playerId);
            statement.setInt(2, seasonId);
            if (fromClubId == null) {
                statement.setNull(3, java.sql.Types.INTEGER);
            } else {
                statement.setInt(3, fromClubId);
            }
            statement.setInt(4, toClubId);
            statement.setDate(5, transferDate);
            statement.setDouble(6, transferFee);
            statement.setString(7, transferType);
            statement.setString(8, status);
            statement.executeUpdate();
        }
    }

    public void updateTransfer(int transferId, int playerId, int seasonId, Integer fromClubId, int toClubId,
                               Date transferDate, double transferFee, String transferType,
                               String status) throws Exception {
        String sql = """
                UPDATE transfers
                SET player_id = ?, season_id = ?, from_club_id = ?, to_club_id = ?, transfer_date = ?,
                    transfer_fee = ?, transfer_type = ?, status = ?
                WHERE transfer_id = ?
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, playerId);
            statement.setInt(2, seasonId);
            if (fromClubId == null) {
                statement.setNull(3, java.sql.Types.INTEGER);
            } else {
                statement.setInt(3, fromClubId);
            }
            statement.setInt(4, toClubId);
            statement.setDate(5, transferDate);
            statement.setDouble(6, transferFee);
            statement.setString(7, transferType);
            statement.setString(8, status);
            statement.setInt(9, transferId);
            statement.executeUpdate();
        }
    }

    public void deleteTransfer(int transferId) throws Exception {
        String sql = "DELETE FROM transfers WHERE transfer_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, transferId);
            statement.executeUpdate();
        }
    }
}
