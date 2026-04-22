package com.epl.ui;

import com.epl.dao.LookupDAO;
import com.epl.dao.ReportDAO;
import com.epl.model.ComboItem;
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

public class ReportPanel extends JPanel {
    private final LookupDAO lookupDAO = new LookupDAO();
    private final ReportDAO reportDAO = new ReportDAO();

    private final JComboBox<ComboItem> seasonCombo = new JComboBox<>();
    private final JComboBox<ComboItem> clubCombo = new JComboBox<>();
    private final JTextField matchweekField = new JTextField("1");
    private final JTable table = new JTable();

    public ReportPanel() {
        setLayout(new BorderLayout(10, 10));
        setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));

        JPanel topPanel = new JPanel(new GridLayout(2, 4, 8, 8));
        topPanel.setBorder(BorderFactory.createTitledBorder("Run Reports"));
        topPanel.add(new JLabel("Season"));
        topPanel.add(seasonCombo);
        topPanel.add(new JLabel("Club"));
        topPanel.add(clubCombo);
        topPanel.add(new JLabel("Matchweek"));
        topPanel.add(matchweekField);

        JButton standingsButton = new JButton("Standings");
        JButton topScorersButton = new JButton("Top Scorers");
        JButton fixturesButton = new JButton("Fixtures by Matchweek");
        JButton transfersButton = new JButton("Transfers by Club");

        topPanel.add(standingsButton);
        topPanel.add(topScorersButton);
        topPanel.add(fixturesButton);
        topPanel.add(transfersButton);

        TableUtils.configure(table);
        add(topPanel, BorderLayout.NORTH);
        add(new JScrollPane(table), BorderLayout.CENTER);

        loadLookups();

        standingsButton.addActionListener(e -> runStandings());
        topScorersButton.addActionListener(e -> runTopScorers());
        fixturesButton.addActionListener(e -> runFixtures());
        transfersButton.addActionListener(e -> runTransfers());
    }

    private void loadLookups() {
        try {
            seasonCombo.removeAllItems();
            for (ComboItem item : lookupDAO.getSeasons()) seasonCombo.addItem(item);
            clubCombo.removeAllItems();
            for (ComboItem item : lookupDAO.getClubs()) clubCombo.addItem(item);
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void runStandings() {
        try {
            ComboItem season = requireSeason();
            table.setModel(reportDAO.getStandings(season.getId()));
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void runTopScorers() {
        try {
            ComboItem season = requireSeason();
            table.setModel(reportDAO.getTopScorers(season.getId()));
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void runFixtures() {
        try {
            ComboItem season = requireSeason();
            int matchweek = UIUtils.parseInteger(matchweekField.getText(), "Matchweek");
            table.setModel(reportDAO.getFixturesByMatchweek(season.getId(), matchweek));
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void runTransfers() {
        try {
            ComboItem club = (ComboItem) clubCombo.getSelectedItem();
            if (club == null) throw new IllegalArgumentException("Please select a club.");
            table.setModel(reportDAO.getTransfersByClub(club.getId()));
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private ComboItem requireSeason() {
        ComboItem season = (ComboItem) seasonCombo.getSelectedItem();
        if (season == null) {
            throw new IllegalArgumentException("Please select a season.");
        }
        return season;
    }
}
