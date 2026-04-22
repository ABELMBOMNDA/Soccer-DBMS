package com.epl.ui;

import com.epl.dao.FixtureDAO;
import com.epl.dao.LookupDAO;
import com.epl.model.ComboItem;
import com.epl.util.TableUtils;
import com.epl.util.UIUtils;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.ListSelectionModel;
import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.sql.Timestamp;

public class FixturePanel extends JPanel {
    private final FixtureDAO fixtureDAO = new FixtureDAO();
    private final LookupDAO lookupDAO = new LookupDAO();

    private final JTextField fixtureIdField = new JTextField();
    private final JTextField matchweekField = new JTextField();
    private final JTextField matchDateField = new JTextField();
    private final JTextField homeScoreField = new JTextField();
    private final JTextField awayScoreField = new JTextField();
    private final JTextField attendanceField = new JTextField();
    private final JComboBox<ComboItem> seasonCombo = new JComboBox<>();
    private final JComboBox<ComboItem> stadiumCombo = new JComboBox<>();
    private final JComboBox<ComboItem> homeClubCombo = new JComboBox<>();
    private final JComboBox<ComboItem> awayClubCombo = new JComboBox<>();
    private final JComboBox<String> statusCombo = new JComboBox<>(new String[]{"SCHEDULED", "COMPLETED", "POSTPONED", "CANCELLED"});
    private final JTable table = new JTable();

    public FixturePanel() {
        setLayout(new BorderLayout(10, 10));
        setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));

        fixtureIdField.setEditable(false);
        JPanel formPanel = new JPanel(new GridLayout(6, 4, 8, 8));
        formPanel.setBorder(BorderFactory.createTitledBorder("Fixture Details"));
        formPanel.add(new JLabel("Fixture ID"));
        formPanel.add(fixtureIdField);
        formPanel.add(new JLabel("Season"));
        formPanel.add(seasonCombo);
        formPanel.add(new JLabel("Matchweek"));
        formPanel.add(matchweekField);
        formPanel.add(new JLabel("Match Date (YYYY-MM-DD HH:MM:SS)"));
        formPanel.add(matchDateField);
        formPanel.add(new JLabel("Stadium"));
        formPanel.add(stadiumCombo);
        formPanel.add(new JLabel("Home Club"));
        formPanel.add(homeClubCombo);
        formPanel.add(new JLabel("Away Club"));
        formPanel.add(awayClubCombo);
        formPanel.add(new JLabel("Home Score"));
        formPanel.add(homeScoreField);
        formPanel.add(new JLabel("Away Score"));
        formPanel.add(awayScoreField);
        formPanel.add(new JLabel("Status"));
        formPanel.add(statusCombo);
        formPanel.add(new JLabel("Attendance"));
        formPanel.add(attendanceField);

        JButton loadButton = new JButton("Load Fixtures");
        JButton addButton = new JButton("Add Fixture");
        JButton updateButton = new JButton("Update Fixture");
        JButton deleteButton = new JButton("Delete Fixture");
        JButton clearButton = new JButton("Clear Form");

        JPanel buttonPanel = new JPanel();
        buttonPanel.add(loadButton);
        buttonPanel.add(addButton);
        buttonPanel.add(updateButton);
        buttonPanel.add(deleteButton);
        buttonPanel.add(clearButton);

        table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        TableUtils.configure(table);
        table.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting() && table.getSelectedRow() >= 0) {
                int row = table.convertRowIndexToModel(table.getSelectedRow());
                fixtureIdField.setText(String.valueOf(table.getModel().getValueAt(row, 0)));
                matchweekField.setText(String.valueOf(table.getModel().getValueAt(row, 2)));
                matchDateField.setText(String.valueOf(table.getModel().getValueAt(row, 3)) + ":00");
                String score = String.valueOf(table.getModel().getValueAt(row, 7));
                String[] parts = score.split("-");
                if (parts.length == 2) {
                    homeScoreField.setText(parts[0].trim());
                    awayScoreField.setText(parts[1].trim());
                }
                statusCombo.setSelectedItem(String.valueOf(table.getModel().getValueAt(row, 8)));
                attendanceField.setText(String.valueOf(table.getModel().getValueAt(row, 9)));
            }
        });

        add(formPanel, BorderLayout.NORTH);
        add(new JScrollPane(table), BorderLayout.CENTER);
        add(buttonPanel, BorderLayout.SOUTH);

        loadLookups();
        loadTable();

        loadButton.addActionListener(e -> loadTable());
        clearButton.addActionListener(e -> clearForm());
        addButton.addActionListener(e -> addFixture());
        updateButton.addActionListener(e -> updateFixture());
        deleteButton.addActionListener(e -> deleteFixture());
    }

    private void loadLookups() {
        try {
            seasonCombo.removeAllItems();
            for (ComboItem item : lookupDAO.getSeasons()) seasonCombo.addItem(item);
            stadiumCombo.removeAllItems();
            for (ComboItem item : lookupDAO.getStadiums()) stadiumCombo.addItem(item);
            homeClubCombo.removeAllItems();
            awayClubCombo.removeAllItems();
            for (ComboItem item : lookupDAO.getClubs()) {
                homeClubCombo.addItem(item);
                awayClubCombo.addItem(item);
            }
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void loadTable() {
        try {
            table.setModel(fixtureDAO.getAllFixtures());
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void addFixture() {
        try {
            ComboItem season = (ComboItem) seasonCombo.getSelectedItem();
            ComboItem stadium = (ComboItem) stadiumCombo.getSelectedItem();
            ComboItem homeClub = (ComboItem) homeClubCombo.getSelectedItem();
            ComboItem awayClub = (ComboItem) awayClubCombo.getSelectedItem();
            int matchweek = UIUtils.parseInteger(UIUtils.required(matchweekField, "Matchweek"), "Matchweek");
            Timestamp matchDate = Timestamp.valueOf(UIUtils.required(matchDateField, "Match date"));
            int homeScore = UIUtils.parseInteger(UIUtils.required(homeScoreField, "Home score"), "Home score");
            int awayScore = UIUtils.parseInteger(UIUtils.required(awayScoreField, "Away score"), "Away score");
            int attendance = UIUtils.parseInteger(UIUtils.required(attendanceField, "Attendance"), "Attendance");
            String status = String.valueOf(statusCombo.getSelectedItem());

            validateFixtureSelection(season, stadium, homeClub, awayClub);
            fixtureDAO.insertFixture(season.getId(), matchweek, matchDate, stadium.getId(), homeClub.getId(), awayClub.getId(),
                    homeScore, awayScore, status, attendance);
            loadTable();
            clearForm();
            UIUtils.showInfo(this, "Fixture added successfully.");
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void updateFixture() {
        try {
            int fixtureId = UIUtils.parseInteger(UIUtils.required(fixtureIdField, "Fixture ID"), "Fixture ID");
            ComboItem season = (ComboItem) seasonCombo.getSelectedItem();
            ComboItem stadium = (ComboItem) stadiumCombo.getSelectedItem();
            ComboItem homeClub = (ComboItem) homeClubCombo.getSelectedItem();
            ComboItem awayClub = (ComboItem) awayClubCombo.getSelectedItem();
            int matchweek = UIUtils.parseInteger(UIUtils.required(matchweekField, "Matchweek"), "Matchweek");
            Timestamp matchDate = Timestamp.valueOf(UIUtils.required(matchDateField, "Match date"));
            int homeScore = UIUtils.parseInteger(UIUtils.required(homeScoreField, "Home score"), "Home score");
            int awayScore = UIUtils.parseInteger(UIUtils.required(awayScoreField, "Away score"), "Away score");
            int attendance = UIUtils.parseInteger(UIUtils.required(attendanceField, "Attendance"), "Attendance");
            String status = String.valueOf(statusCombo.getSelectedItem());

            validateFixtureSelection(season, stadium, homeClub, awayClub);
            fixtureDAO.updateFixture(fixtureId, season.getId(), matchweek, matchDate, stadium.getId(), homeClub.getId(), awayClub.getId(),
                    homeScore, awayScore, status, attendance);
            loadTable();
            clearForm();
            UIUtils.showInfo(this, "Fixture updated successfully.");
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void deleteFixture() {
        try {
            int fixtureId = UIUtils.parseInteger(UIUtils.required(fixtureIdField, "Fixture ID"), "Fixture ID");
            int confirm = JOptionPane.showConfirmDialog(this, "Delete selected fixture?", "Confirm", JOptionPane.YES_NO_OPTION);
            if (confirm == JOptionPane.YES_OPTION) {
                fixtureDAO.deleteFixture(fixtureId);
                loadTable();
                clearForm();
                UIUtils.showInfo(this, "Fixture deleted successfully.");
            }
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void validateFixtureSelection(ComboItem season, ComboItem stadium, ComboItem homeClub, ComboItem awayClub) {
        if (season == null || stadium == null || homeClub == null || awayClub == null) {
            throw new IllegalArgumentException("Season, stadium, home club, and away club are all required.");
        }
        if (homeClub.getId() == awayClub.getId()) {
            throw new IllegalArgumentException("Home club and away club must be different.");
        }
    }

    private void clearForm() {
        fixtureIdField.setText("");
        matchweekField.setText("");
        matchDateField.setText("");
        homeScoreField.setText("0");
        awayScoreField.setText("0");
        attendanceField.setText("0");
        if (seasonCombo.getItemCount() > 0) seasonCombo.setSelectedIndex(0);
        if (stadiumCombo.getItemCount() > 0) stadiumCombo.setSelectedIndex(0);
        if (homeClubCombo.getItemCount() > 0) homeClubCombo.setSelectedIndex(0);
        if (awayClubCombo.getItemCount() > 1) awayClubCombo.setSelectedIndex(1);
        statusCombo.setSelectedIndex(0);
    }
}
