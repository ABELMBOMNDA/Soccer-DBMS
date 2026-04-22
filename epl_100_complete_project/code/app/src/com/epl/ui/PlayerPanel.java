package com.epl.ui;

import com.epl.dao.LookupDAO;
import com.epl.dao.PlayerDAO;
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
import java.sql.Date;

public class PlayerPanel extends JPanel {
    private final PlayerDAO playerDAO = new PlayerDAO();
    private final LookupDAO lookupDAO = new LookupDAO();

    private final JTextField playerIdField = new JTextField();
    private final JTextField firstNameField = new JTextField();
    private final JTextField lastNameField = new JTextField();
    private final JTextField dobField = new JTextField();
    private final JTextField nationalityField = new JTextField();
    private final JTextField squadNumberField = new JTextField();
    private final JTextField marketValueField = new JTextField();
    private final JComboBox<ComboItem> positionCombo = new JComboBox<>();
    private final JComboBox<ComboItem> clubCombo = new JComboBox<>();
    private final JComboBox<String> footCombo = new JComboBox<>(new String[]{"Right", "Left", "Both"});
    private final JTable table = new JTable();

    public PlayerPanel() {
        setLayout(new BorderLayout(10, 10));
        setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));

        playerIdField.setEditable(false);
        JPanel formPanel = new JPanel(new GridLayout(5, 4, 8, 8));
        formPanel.setBorder(BorderFactory.createTitledBorder("Player Details"));
        formPanel.add(new JLabel("Player ID"));
        formPanel.add(playerIdField);
        formPanel.add(new JLabel("First Name"));
        formPanel.add(firstNameField);
        formPanel.add(new JLabel("Last Name"));
        formPanel.add(lastNameField);
        formPanel.add(new JLabel("Date of Birth (YYYY-MM-DD)"));
        formPanel.add(dobField);
        formPanel.add(new JLabel("Nationality"));
        formPanel.add(nationalityField);
        formPanel.add(new JLabel("Position"));
        formPanel.add(positionCombo);
        formPanel.add(new JLabel("Squad Number"));
        formPanel.add(squadNumberField);
        formPanel.add(new JLabel("Preferred Foot"));
        formPanel.add(footCombo);
        formPanel.add(new JLabel("Current Club"));
        formPanel.add(clubCombo);
        formPanel.add(new JLabel("Market Value"));
        formPanel.add(marketValueField);

        JButton loadButton = new JButton("Load Players");
        JButton addButton = new JButton("Add Player");
        JButton updateButton = new JButton("Update Player");
        JButton deleteButton = new JButton("Delete Player");
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
                playerIdField.setText(String.valueOf(table.getModel().getValueAt(row, 0)));
                String fullName = String.valueOf(table.getModel().getValueAt(row, 1));
                String[] parts = fullName.split(" ", 2);
                firstNameField.setText(parts.length > 0 ? parts[0] : "");
                lastNameField.setText(parts.length > 1 ? parts[1] : "");
                dobField.setText(String.valueOf(table.getModel().getValueAt(row, 2)));
                nationalityField.setText(String.valueOf(table.getModel().getValueAt(row, 3)));
                squadNumberField.setText(String.valueOf(table.getModel().getValueAt(row, 5)));
                footCombo.setSelectedItem(String.valueOf(table.getModel().getValueAt(row, 6)));
                marketValueField.setText(String.valueOf(table.getModel().getValueAt(row, 8)));
            }
        });

        add(formPanel, BorderLayout.NORTH);
        add(new JScrollPane(table), BorderLayout.CENTER);
        add(buttonPanel, BorderLayout.SOUTH);

        loadLookups();
        loadTable();

        loadButton.addActionListener(e -> loadTable());
        clearButton.addActionListener(e -> clearForm());
        addButton.addActionListener(e -> addPlayer());
        updateButton.addActionListener(e -> updatePlayer());
        deleteButton.addActionListener(e -> deletePlayer());
    }

    private void loadLookups() {
        try {
            positionCombo.removeAllItems();
            for (ComboItem item : lookupDAO.getPositions()) {
                positionCombo.addItem(item);
            }
            clubCombo.removeAllItems();
            for (ComboItem item : lookupDAO.getClubs()) {
                clubCombo.addItem(item);
            }
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void loadTable() {
        try {
            table.setModel(playerDAO.getAllPlayers());
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void addPlayer() {
        try {
            String firstName = UIUtils.required(firstNameField, "First name");
            String lastName = UIUtils.required(lastNameField, "Last name");
            Date dob = Date.valueOf(UIUtils.required(dobField, "Date of birth"));
            String nationality = UIUtils.required(nationalityField, "Nationality");
            ComboItem position = (ComboItem) positionCombo.getSelectedItem();
            ComboItem club = (ComboItem) clubCombo.getSelectedItem();
            String foot = String.valueOf(footCombo.getSelectedItem());
            int squadNumber = UIUtils.parseInteger(UIUtils.required(squadNumberField, "Squad number"), "Squad number");
            double marketValue = UIUtils.parseDouble(UIUtils.required(marketValueField, "Market value"), "Market value");
            if (position == null) throw new IllegalArgumentException("Please select a position.");

            playerDAO.insertPlayer(firstName, lastName, dob, nationality, position.getId(), squadNumber,
                    foot, club == null ? null : club.getId(), marketValue);
            loadTable();
            clearForm();
            UIUtils.showInfo(this, "Player added successfully.");
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void updatePlayer() {
        try {
            int playerId = UIUtils.parseInteger(UIUtils.required(playerIdField, "Player ID"), "Player ID");
            String firstName = UIUtils.required(firstNameField, "First name");
            String lastName = UIUtils.required(lastNameField, "Last name");
            Date dob = Date.valueOf(UIUtils.required(dobField, "Date of birth"));
            String nationality = UIUtils.required(nationalityField, "Nationality");
            ComboItem position = (ComboItem) positionCombo.getSelectedItem();
            ComboItem club = (ComboItem) clubCombo.getSelectedItem();
            String foot = String.valueOf(footCombo.getSelectedItem());
            int squadNumber = UIUtils.parseInteger(UIUtils.required(squadNumberField, "Squad number"), "Squad number");
            double marketValue = UIUtils.parseDouble(UIUtils.required(marketValueField, "Market value"), "Market value");
            if (position == null) throw new IllegalArgumentException("Please select a position.");

            playerDAO.updatePlayer(playerId, firstName, lastName, dob, nationality, position.getId(), squadNumber,
                    foot, club == null ? null : club.getId(), marketValue);
            loadTable();
            clearForm();
            UIUtils.showInfo(this, "Player updated successfully.");
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void deletePlayer() {
        try {
            int playerId = UIUtils.parseInteger(UIUtils.required(playerIdField, "Player ID"), "Player ID");
            int confirm = JOptionPane.showConfirmDialog(this, "Delete selected player?", "Confirm", JOptionPane.YES_NO_OPTION);
            if (confirm == JOptionPane.YES_OPTION) {
                playerDAO.deletePlayer(playerId);
                loadTable();
                clearForm();
                UIUtils.showInfo(this, "Player deleted successfully.");
            }
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void clearForm() {
        playerIdField.setText("");
        firstNameField.setText("");
        lastNameField.setText("");
        dobField.setText("");
        nationalityField.setText("");
        squadNumberField.setText("");
        marketValueField.setText("");
        if (positionCombo.getItemCount() > 0) positionCombo.setSelectedIndex(0);
        if (clubCombo.getItemCount() > 0) clubCombo.setSelectedIndex(0);
        footCombo.setSelectedIndex(0);
    }
}
