package com.epl.ui;

import javax.swing.JFrame;
import javax.swing.JTabbedPane;
import javax.swing.UIManager;

public class MainFrame extends JFrame {
    public MainFrame() {
        setTitle("English Premier League DBMS Application");
        setSize(1280, 760);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        JTabbedPane tabs = new JTabbedPane();
        tabs.addTab("Dashboard", new DashboardPanel());
        tabs.addTab("Clubs", new ClubPanel());
        tabs.addTab("Players", new PlayerPanel());
        tabs.addTab("Fixtures", new FixturePanel());
        tabs.addTab("Transfers", new TransferPanel());
        tabs.addTab("Official Squads", new OfficialSquadPanel());
        tabs.addTab("Reports", new ReportPanel());

        setContentPane(tabs);
    }

    public static void applySystemLookAndFeel() {
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ignored) {
        }
    }
}
