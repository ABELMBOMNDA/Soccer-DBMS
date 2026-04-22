package com.epl.ui;

import com.epl.dao.OfficialSquadDAO;
import com.epl.dao.ReportDAO;
import com.epl.util.UIUtils;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import java.awt.BorderLayout;
import java.awt.Font;
import java.awt.GridLayout;

public class DashboardPanel extends JPanel {
    private final JLabel clubsValue = new JLabel("0");
    private final JLabel playersValue = new JLabel("0");
    private final JLabel fixturesValue = new JLabel("0");
    private final JLabel transfersValue = new JLabel("0");
    private final JLabel officialSquadsValue = new JLabel("0");
    private final JLabel snapshotValue = new JLabel("Not loaded");

    private final ReportDAO reportDAO = new ReportDAO();
    private final OfficialSquadDAO officialSquadDAO = new OfficialSquadDAO();

    public DashboardPanel() {
        setLayout(new BorderLayout(12, 12));
        setBorder(BorderFactory.createEmptyBorder(16, 16, 16, 16));

        JTextArea intro = new JTextArea(
                "English Premier League Database Management System\n\n" +
                "This Java Swing + MySQL application now includes the full DBMS project flow: " +
                "clubs, players, fixtures, transfers, SQL reports, and the official Premier League " +
                "registered squad snapshot integrated into the application UI."
        );
        intro.setLineWrap(true);
        intro.setWrapStyleWord(true);
        intro.setEditable(false);
        intro.setFont(new Font(Font.SANS_SERIF, Font.PLAIN, 15));
        intro.setBackground(getBackground());

        JPanel statsPanel = new JPanel(new GridLayout(2, 3, 12, 12));
        statsPanel.add(createStatCard("Clubs", clubsValue));
        statsPanel.add(createStatCard("Players", playersValue));
        statsPanel.add(createStatCard("Fixtures", fixturesValue));
        statsPanel.add(createStatCard("Transfers", transfersValue));
        statsPanel.add(createStatCard("Official Squad Entries", officialSquadsValue));
        statsPanel.add(createStatCard("Latest Official Snapshot", snapshotValue));

        JButton refreshButton = new JButton("Refresh Dashboard");
        refreshButton.addActionListener(e -> refreshCounts());

        add(intro, BorderLayout.NORTH);
        add(statsPanel, BorderLayout.CENTER);
        add(refreshButton, BorderLayout.SOUTH);

        refreshCounts();
    }

    private JPanel createStatCard(String title, JLabel valueLabel) {
        JPanel panel = new JPanel(new BorderLayout());
        panel.setBorder(BorderFactory.createTitledBorder(title));
        valueLabel.setHorizontalAlignment(JLabel.CENTER);
        valueLabel.setFont(new Font(Font.SANS_SERIF, Font.BOLD, title.contains("Snapshot") ? 16 : 30));
        panel.add(valueLabel, BorderLayout.CENTER);
        return panel;
    }

    private void refreshCounts() {
        try {
            clubsValue.setText(String.valueOf(reportDAO.countRows("clubs")));
            playersValue.setText(String.valueOf(reportDAO.countRows("players")));
            fixturesValue.setText(String.valueOf(reportDAO.countRows("fixtures")));
            transfersValue.setText(String.valueOf(reportDAO.countRows("transfers")));
            officialSquadsValue.setText(String.valueOf(reportDAO.countRows("official_registered_squads")));
            snapshotValue.setText(officialSquadDAO.getLatestSnapshotLabel());
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }
}
