package com.epl.ui;

import com.epl.dao.LookupDAO;
import com.epl.dao.TransferDAO;
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

public class TransferPanel extends JPanel {
    private final TransferDAO transferDAO = new TransferDAO();
    private final LookupDAO lookupDAO = new LookupDAO();

    private final JTextField transferIdField = new JTextField();
    private final JTextField transferDateField = new JTextField();
    private final JTextField feeField = new JTextField();
    private final JComboBox<ComboItem> playerCombo = new JComboBox<>();
    private final JComboBox<ComboItem> seasonCombo = new JComboBox<>();
    private final JComboBox<ComboItem> fromClubCombo = new JComboBox<>();
    private final JComboBox<ComboItem> toClubCombo = new JComboBox<>();
    private final JComboBox<String> transferTypeCombo = new JComboBox<>(new String[]{"PERMANENT", "LOAN", "FREE_AGENT"});
    private final JComboBox<String> statusCombo = new JComboBox<>(new String[]{"PENDING", "COMPLETED", "CANCELLED"});
    private final JTable table = new JTable();

    public TransferPanel() {
        setLayout(new BorderLayout(10, 10));
        setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));

        transferIdField.setEditable(false);
        JPanel formPanel = new JPanel(new GridLayout(5, 4, 8, 8));
        formPanel.setBorder(BorderFactory.createTitledBorder("Transfer Details"));
        formPanel.add(new JLabel("Transfer ID"));
        formPanel.add(transferIdField);
        formPanel.add(new JLabel("Player"));
        formPanel.add(playerCombo);
        formPanel.add(new JLabel("Season"));
        formPanel.add(seasonCombo);
        formPanel.add(new JLabel("From Club"));
        formPanel.add(fromClubCombo);
        formPanel.add(new JLabel("To Club"));
        formPanel.add(toClubCombo);
        formPanel.add(new JLabel("Transfer Date (YYYY-MM-DD)"));
        formPanel.add(transferDateField);
        formPanel.add(new JLabel("Transfer Fee"));
        formPanel.add(feeField);
        formPanel.add(new JLabel("Transfer Type"));
        formPanel.add(transferTypeCombo);
        formPanel.add(new JLabel("Status"));
        formPanel.add(statusCombo);

        JButton loadButton = new JButton("Load Transfers");
        JButton addButton = new JButton("Add Transfer");
        JButton updateButton = new JButton("Update Transfer");
        JButton deleteButton = new JButton("Delete Transfer");
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
                transferIdField.setText(String.valueOf(table.getModel().getValueAt(row, 0)));
                transferDateField.setText(String.valueOf(table.getModel().getValueAt(row, 4)));
                feeField.setText(String.valueOf(table.getModel().getValueAt(row, 5)));
                transferTypeCombo.setSelectedItem(String.valueOf(table.getModel().getValueAt(row, 6)));
                statusCombo.setSelectedItem(String.valueOf(table.getModel().getValueAt(row, 7)));
            }
        });

        add(formPanel, BorderLayout.NORTH);
        add(new JScrollPane(table), BorderLayout.CENTER);
        add(buttonPanel, BorderLayout.SOUTH);

        loadLookups();
        loadTable();

        loadButton.addActionListener(e -> loadTable());
        clearButton.addActionListener(e -> clearForm());
        addButton.addActionListener(e -> addTransfer());
        updateButton.addActionListener(e -> updateTransfer());
        deleteButton.addActionListener(e -> deleteTransfer());
    }

    private void loadLookups() {
        try {
            playerCombo.removeAllItems();
            for (ComboItem item : lookupDAO.getPlayers()) playerCombo.addItem(item);
            seasonCombo.removeAllItems();
            for (ComboItem item : lookupDAO.getSeasons()) seasonCombo.addItem(item);
            fromClubCombo.removeAllItems();
            toClubCombo.removeAllItems();
            fromClubCombo.addItem(new ComboItem(0, "Free Agent / None"));
            for (ComboItem item : lookupDAO.getClubs()) {
                fromClubCombo.addItem(item);
                toClubCombo.addItem(item);
            }
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void loadTable() {
        try {
            table.setModel(transferDAO.getAllTransfers());
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void addTransfer() {
        try {
            ComboItem player = (ComboItem) playerCombo.getSelectedItem();
            ComboItem season = (ComboItem) seasonCombo.getSelectedItem();
            ComboItem fromClub = (ComboItem) fromClubCombo.getSelectedItem();
            ComboItem toClub = (ComboItem) toClubCombo.getSelectedItem();
            Date transferDate = Date.valueOf(UIUtils.required(transferDateField, "Transfer date"));
            double fee = UIUtils.parseDouble(UIUtils.required(feeField, "Transfer fee"), "Transfer fee");
            String transferType = String.valueOf(transferTypeCombo.getSelectedItem());
            String status = String.valueOf(statusCombo.getSelectedItem());
            validateSelection(player, season, toClub, fromClub);
            Integer fromClubId = (fromClub == null || fromClub.getId() == 0) ? null : fromClub.getId();

            transferDAO.insertTransfer(player.getId(), season.getId(), fromClubId,
                    toClub.getId(), transferDate, fee, transferType, status);
            loadTable();
            clearForm();
            UIUtils.showInfo(this, "Transfer added successfully.");
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void updateTransfer() {
        try {
            int transferId = UIUtils.parseInteger(UIUtils.required(transferIdField, "Transfer ID"), "Transfer ID");
            ComboItem player = (ComboItem) playerCombo.getSelectedItem();
            ComboItem season = (ComboItem) seasonCombo.getSelectedItem();
            ComboItem fromClub = (ComboItem) fromClubCombo.getSelectedItem();
            ComboItem toClub = (ComboItem) toClubCombo.getSelectedItem();
            Date transferDate = Date.valueOf(UIUtils.required(transferDateField, "Transfer date"));
            double fee = UIUtils.parseDouble(UIUtils.required(feeField, "Transfer fee"), "Transfer fee");
            String transferType = String.valueOf(transferTypeCombo.getSelectedItem());
            String status = String.valueOf(statusCombo.getSelectedItem());
            validateSelection(player, season, toClub, fromClub);
            Integer fromClubId = (fromClub == null || fromClub.getId() == 0) ? null : fromClub.getId();

            transferDAO.updateTransfer(transferId, player.getId(), season.getId(), fromClubId,
                    toClub.getId(), transferDate, fee, transferType, status);
            loadTable();
            clearForm();
            UIUtils.showInfo(this, "Transfer updated successfully.");
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void deleteTransfer() {
        try {
            int transferId = UIUtils.parseInteger(UIUtils.required(transferIdField, "Transfer ID"), "Transfer ID");
            int confirm = JOptionPane.showConfirmDialog(this, "Delete selected transfer?", "Confirm", JOptionPane.YES_NO_OPTION);
            if (confirm == JOptionPane.YES_OPTION) {
                transferDAO.deleteTransfer(transferId);
                loadTable();
                clearForm();
                UIUtils.showInfo(this, "Transfer deleted successfully.");
            }
        } catch (Exception ex) {
            UIUtils.showError(this, ex);
        }
    }

    private void validateSelection(ComboItem player, ComboItem season, ComboItem toClub, ComboItem fromClub) {
        if (player == null || season == null || toClub == null) {
            throw new IllegalArgumentException("Player, season, and destination club are required.");
        }
        if (fromClub != null && fromClub.getId() != 0 && fromClub.getId() == toClub.getId()) {
            throw new IllegalArgumentException("From club and to club must be different.");
        }
    }

    private void clearForm() {
        transferIdField.setText("");
        transferDateField.setText("");
        feeField.setText("0");
        if (playerCombo.getItemCount() > 0) playerCombo.setSelectedIndex(0);
        if (seasonCombo.getItemCount() > 0) seasonCombo.setSelectedIndex(0);
        if (fromClubCombo.getItemCount() > 0) fromClubCombo.setSelectedIndex(0);
        if (toClubCombo.getItemCount() > 1) toClubCombo.setSelectedIndex(1);
        transferTypeCombo.setSelectedIndex(0);
        statusCombo.setSelectedIndex(1);
    }
}
