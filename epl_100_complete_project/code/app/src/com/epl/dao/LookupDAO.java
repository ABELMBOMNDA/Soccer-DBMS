package com.epl.dao;

import com.epl.db.DBConnection;
import com.epl.model.ComboItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class LookupDAO {
    private List<ComboItem> loadItems(String sql) throws Exception {
        List<ComboItem> items = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                items.add(new ComboItem(rs.getInt(1), rs.getString(2)));
            }
        }
        return items;
    }

    public List<ComboItem> getClubs() throws Exception {
        return loadItems("SELECT club_id, club_name FROM clubs ORDER BY club_name");
    }

    public List<ComboItem> getSeasons() throws Exception {
        return loadItems("SELECT season_id, season_name FROM seasons ORDER BY start_date DESC");
    }

    public List<ComboItem> getStadiums() throws Exception {
        return loadItems("SELECT stadium_id, stadium_name FROM stadiums ORDER BY stadium_name");
    }

    public List<ComboItem> getPositions() throws Exception {
        return loadItems("SELECT position_id, CONCAT(position_code, ' - ', position_name) FROM positions ORDER BY position_code");
    }

    public List<ComboItem> getPlayers() throws Exception {
        return loadItems("SELECT player_id, CONCAT(first_name, ' ', last_name) FROM players ORDER BY last_name, first_name");
    }
}
