package com.epl.ui;

import com.epl.dao.ClubDAO;
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

public class ClubPanel extends JPanel {
    private final ClubDAO clubDAO = new ClubDAO();
    private final LookupDAO lookupDAO = new LookupDAO();

    private final JTextField clubIdField = new JTextField();
    private final JTextField clubNameField = new JTextField();
    private final JTextField shortNameField = new JTextField();
    private final JTextField foundedYearField = new JTextField();
    private final JTextField managerField = new JTextField();
    private final JTextField sponsorField = new JTextField();
    private final JComboBox<ComboItem> stadiumCombo = new JComboBox<>();
    private final JTable table = new JTable();

    public ClubPanel() {
        setLayout(new BorderLayout(10, 10));
        setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));

        clubIdField.setEditable(false);
        JPanel formPanel = new JPanel(new GridLayout(4, 4, 8, 8));
        formPanel.setBorder(BorderFactory.createTitledBorder("Club Details"));
        formPanel.add(new JLabel("Club ID"));
        formPanel.add(clubIdField);
        formPanel.add(new JLabel("Club Name"));
        formPanel.add(clubNameField);
        formPanel.add(new JLabel("Short Name"));
        formPanel.add(shortNameField);
        formPanel.add(new JLabel("Founded Year"));
        formPanel.add(foundedYearField);
        formPanel.add(new JLabel("Manager Name"));
        formPanel.add(managerField);
        formPanel.add(new JLabel("Sponsor Name"));
        formPanel.add(sponsorField);
        formPanel.add(new JLabel("Home Stadium"));
        formPanel.add(stadiumCombo);

        JButton loadButton = new JButton("Load Clubs");
        JButton addButton = new JButton("Add Club");
        JButton updateButton = new JButton("Update Club");
        JButton deleteButton = new JButton("Delete Club");
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
                clubIdField.setText(String.valueOf(table.getModel().getValueAt(row, 0)));
                clubNameField.setText(String.valueOf(table.getModel().getValueAt(row, 1)));
                shortNameField.setText(String.valueOf(table.getModel().getValueAt(row, 2)));
                foundedYearField.setText(String.valueOf(table.getModel().getValueAt(row, 3)));
                managerField.setText(String.valueOf(table.getModel().getValueAt(row, 4)));
                sponsorField.setText(String.valueOf(table.getModel().getValueAt(row, 5)));
            }
        });

        add(formPanel, BorderLayout.NORTH);
        add(new JScrollPane(table), BorderLayout.CENTER);
        add(buttonPanel, BorderLayout.SOUTH);

        loadLookups();
        loadTable();

        loadButton.addActionListener(e -> loadTable());
        clearButton.addActionListener(e -> clearForm());
        addButton.addActionListener(e -> addClub());
        updateButton.addActionListener(e -> updateClub());
        deleteButton.addActionListener(e -> deleteClub());
    }

    private void loadLookups() {
        try {
            stadiumCombo.removeAllItems();
            for (ComboItem item : lookupDAO.getStadiums()) {
                stadiumCombo.addItem(item);
            }
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void loadTable() {
        try {
            table.setModel(clubDAO.getAllClubs());
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void addClub() {
        try {
            String clubName = UIUtils.required(clubNameField, "Club name");
            String shortName = UIUtils.required(shortNameField, "Short name");
            int foundedYear = UIUtils.parseInteger(UIUtils.required(foundedYearField, "Founded year"), "Founded year");
            String managerName = UIUtils.required(managerField, "Manager name");
            String sponsorName = sponsorField.getText().trim();
            ComboItem stadium = (ComboItem) stadiumCombo.getSelectedItem();
            if (stadium == null) throw new IllegalArgumentException("Please select a stadium.");

            clubDAO.insertClub(clubName, shortName, foundedYear, managerName, sponsorName, stadium.getId());
            loadTable();
            clearForm();
            UIUtils.showInfo(this, "Club added successfully.");
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void updateClub() {
        try {
            int clubId = UIUtils.parseInteger(UIUtils.required(clubIdField, "Club ID"), "Club ID");
            String clubName = UIUtils.required(clubNameField, "Club name");
            String shortName = UIUtils.required(shortNameField, "Short name");
            int foundedYear = UIUtils.parseInteger(UIUtils.required(foundedYearField, "Founded year"), "Founded year");
            String managerName = UIUtils.required(managerField, "Manager name");
            String sponsorName = sponsorField.getText().trim();
            ComboItem stadium = (ComboItem) stadiumCombo.getSelectedItem();
            if (stadium == null) throw new IllegalArgumentException("Please select a stadium.");

            clubDAO.updateClub(clubId, clubName, shortName, foundedYear, managerName, sponsorName, stadium.getId());
            loadTable();
            clearForm();
            UIUtils.showInfo(this, "Club updated successfully.");
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void deleteClub() {
        try {
            int clubId = UIUtils.parseInteger(UIUtils.required(clubIdField, "Club ID"), "Club ID");
            int confirm = JOptionPane.showConfirmDialog(this, "Delete selected club?", "Confirm", JOptionPane.YES_NO_OPTION);
            if (confirm == JOptionPane.YES_OPTION) {
                clubDAO.deleteClub(clubId);
                loadTable();
                clearForm();
                UIUtils.showInfo(this, "Club deleted successfully.");
            }
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void clearForm() {
        clubIdField.setText("");
        clubNameField.setText("");
        shortNameField.setText("");
        foundedYearField.setText("");
        managerField.setText("");
        sponsorField.setText("");
        if (stadiumCombo.getItemCount() > 0) stadiumCombo.setSelectedIndex(0);
    }
}
