package com.epl.dao;

import com.epl.db.DBConnection;
import com.epl.util.TableUtils;

import javax.swing.table.DefaultTableModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OfficialSquadDAO {
    public List<String> getSeasonNames() throws Exception {
        String sql = "SELECT DISTINCT season_name FROM official_registered_squads ORDER BY source_snapshot_date DESC, season_name DESC";
        List<String> seasons = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                seasons.add(rs.getString(1));
            }
        }
        return seasons;
    }

    public List<String> getClubNames(String seasonName) throws Exception {
        String sql = "SELECT DISTINCT club_name FROM official_registered_squads WHERE season_name = ? ORDER BY club_name";
        List<String> clubs = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, seasonName);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    clubs.add(rs.getString(1));
                }
            }
        }
        return clubs;
    }

    public DefaultTableModel getOfficialSquads(String seasonName, String clubName, String playerKeyword) throws Exception {
        StringBuilder sql = new StringBuilder(
                "SELECT season_name, source_snapshot_date, club_name, player_name, " +
                "CASE WHEN is_home_grown THEN 'Yes' ELSE 'No' END AS home_grown, squad_scope " +
                "FROM official_registered_squads WHERE season_name = ?"
        );
        List<String> params = new ArrayList<>();
        params.add(seasonName);

        if (clubName != null && !clubName.isBlank() && !"All Clubs".equalsIgnoreCase(clubName)) {
            sql.append(" AND club_name = ?");
            params.add(clubName);
        }
        if (playerKeyword != null && !playerKeyword.isBlank()) {
            sql.append(" AND player_name LIKE ?");
            params.add("%" + playerKeyword.trim() + "%");
        }
        sql.append(" ORDER BY club_name, player_name");

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                statement.setString(i + 1, params.get(i));
            }
            try (ResultSet rs = statement.executeQuery()) {
                return TableUtils.toTableModel(rs);
            }
        }
    }

    public DefaultTableModel getClubSummary(String seasonName) throws Exception {
        String sql =
                "SELECT club_name, COUNT(*) AS registered_senior_players, " +
                "SUM(CASE WHEN is_home_grown THEN 1 ELSE 0 END) AS home_grown_players, " +
                "SUM(CASE WHEN is_home_grown THEN 0 ELSE 1 END) AS non_home_grown_players " +
                "FROM official_registered_squads WHERE season_name = ? " +
                "GROUP BY club_name ORDER BY club_name";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, seasonName);
            try (ResultSet rs = statement.executeQuery()) {
                return TableUtils.toTableModel(rs);
            }
        }
    }

    public DefaultTableModel getHomeGrownPlayers(String seasonName, String clubName) throws Exception {
        StringBuilder sql = new StringBuilder(
                "SELECT club_name, player_name FROM official_registered_squads " +
                "WHERE season_name = ? AND is_home_grown = TRUE"
        );
        if (clubName != null && !clubName.isBlank() && !"All Clubs".equalsIgnoreCase(clubName)) {
            sql.append(" AND club_name = ?");
        }
        sql.append(" ORDER BY club_name, player_name");

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            statement.setString(1, seasonName);
            if (clubName != null && !clubName.isBlank() && !"All Clubs".equalsIgnoreCase(clubName)) {
                statement.setString(2, clubName);
            }
            try (ResultSet rs = statement.executeQuery()) {
                return TableUtils.toTableModel(rs);
            }
        }
    }

    public String getLatestSnapshotLabel() throws Exception {
        String sql = "SELECT MAX(source_snapshot_date) FROM official_registered_squads";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            if (rs.next() && rs.getDate(1) != null) {
                return rs.getDate(1).toString();
            }
            return "Not loaded";
        }
    }
}
