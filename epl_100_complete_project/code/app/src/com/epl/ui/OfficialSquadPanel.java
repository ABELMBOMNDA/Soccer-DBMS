package com.epl.ui;

import com.epl.dao.OfficialSquadDAO;
import com.epl.util.TableUtils;
import com.epl.util.UIUtils;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import java.awt.BorderLayout;
import java.awt.GridLayout;

public class OfficialSquadPanel extends JPanel {
    private final OfficialSquadDAO officialSquadDAO = new OfficialSquadDAO();

    private final JComboBox<String> seasonCombo = new JComboBox<>();
    private final JComboBox<String> clubCombo = new JComboBox<>();
    private final JTextField playerSearchField = new JTextField();
    private final JTable table = new JTable();

    public OfficialSquadPanel() {
        setLayout(new BorderLayout(10, 10));
        setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));

        JPanel filterPanel = new JPanel(new GridLayout(2, 4, 8, 8));
        filterPanel.setBorder(BorderFactory.createTitledBorder("Official Current Registered Squads"));
        filterPanel.add(new JLabel("Season"));
        filterPanel.add(seasonCombo);
        filterPanel.add(new JLabel("Club"));
        filterPanel.add(clubCombo);
        filterPanel.add(new JLabel("Player Search"));
        filterPanel.add(playerSearchField);

        JButton loadButton = new JButton("Load Official Squad");
        JButton summaryButton = new JButton("Club Summary");
        JButton homeGrownButton = new JButton("Home-Grown Report");
        JButton clearButton = new JButton("Clear Search");

        filterPanel.add(loadButton);
        filterPanel.add(summaryButton);
        filterPanel.add(homeGrownButton);
        filterPanel.add(clearButton);

        TableUtils.configure(table);
        add(filterPanel, BorderLayout.NORTH);
        add(new JScrollPane(table), BorderLayout.CENTER);

        seasonCombo.addActionListener(e -> loadClubs());

        loadLookups();
        loadOfficialSquads();

        loadButton.addActionListener(e -> loadOfficialSquads());
        summaryButton.addActionListener(e -> loadSummary());
        homeGrownButton.addActionListener(e -> loadHomeGrownReport());
        clearButton.addActionListener(e -> {
            playerSearchField.setText("");
            if (clubCombo.getItemCount() > 0) {
                clubCombo.setSelectedIndex(0);
            }
            loadOfficialSquads();
        });
    }

    private void loadLookups() {
        try {
            seasonCombo.removeAllItems();
            for (String season : officialSquadDAO.getSeasonNames()) {
                seasonCombo.addItem(season);
            }
            loadClubs();
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void loadClubs() {
        try {
            String season = getSeason();
            clubCombo.removeAllItems();
            clubCombo.addItem("All Clubs");
            if (season != null) {
                for (String club : officialSquadDAO.getClubNames(season)) {
                    clubCombo.addItem(club);
                }
            }
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private String getSeason() {
        Object selected = seasonCombo.getSelectedItem();
        return selected == null ? null : selected.toString();
    }

    private String getClub() {
        Object selected = clubCombo.getSelectedItem();
        return selected == null ? "All Clubs" : selected.toString();
    }

    private void loadOfficialSquads() {
        try {
            String season = getSeason();
            if (season == null) {
                throw new IllegalArgumentException("No official squad data is loaded yet. Run the sample data SQL script.");
            }
            table.setModel(officialSquadDAO.getOfficialSquads(season, getClub(), playerSearchField.getText()));
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void loadSummary() {
        try {
            String season = getSeason();
            if (season == null) {
                throw new IllegalArgumentException("Please select a season.");
            }
            table.setModel(officialSquadDAO.getClubSummary(season));
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void loadHomeGrownReport() {
        try {
            String season = getSeason();
            if (season == null) {
                throw new IllegalArgumentException("Please select a season.");
            }
            table.setModel(officialSquadDAO.getHomeGrownPlayers(season, getClub()));
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }
}
