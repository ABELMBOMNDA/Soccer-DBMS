package com.epl.dao;

import com.epl.db.DBConnection;
import com.epl.util.TableUtils;

import javax.swing.table.DefaultTableModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ClubDAO {
    public DefaultTableModel getAllClubs() throws Exception {
        String sql = """
                SELECT c.club_id, c.club_name, c.short_name, c.founded_year,
                       c.manager_name, c.sponsor_name, s.stadium_name
                FROM clubs c
                JOIN stadiums s ON c.stadium_id = s.stadium_id
                ORDER BY c.club_name
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            return TableUtils.toTableModel(rs);
        }
    }

    public void insertClub(String clubName, String shortName, int foundedYear,
                           String managerName, String sponsorName, int stadiumId) throws Exception {
        String sql = """
                INSERT INTO clubs (club_name, short_name, founded_year, manager_name, sponsor_name, stadium_id)
                VALUES (?, ?, ?, ?, ?, ?)
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, clubName);
            statement.setString(2, shortName);
            statement.setInt(3, foundedYear);
            statement.setString(4, managerName);
            statement.setString(5, sponsorName);
            statement.setInt(6, stadiumId);
            statement.executeUpdate();
        }
    }

    public void updateClub(int clubId, String clubName, String shortName, int foundedYear,
                           String managerName, String sponsorName, int stadiumId) throws Exception {
        String sql = """
                UPDATE clubs
                SET club_name = ?, short_name = ?, founded_year = ?, manager_name = ?, sponsor_name = ?, stadium_id = ?
                WHERE club_id = ?
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, clubName);
            statement.setString(2, shortName);
            statement.setInt(3, foundedYear);
            statement.setString(4, managerName);
            statement.setString(5, sponsorName);
            statement.setInt(6, stadiumId);
            statement.setInt(7, clubId);
            statement.executeUpdate();
        }
    }

    public void deleteClub(int clubId) throws Exception {
        String sql = "DELETE FROM clubs WHERE club_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, clubId);
            statement.executeUpdate();
        }
    }
}
