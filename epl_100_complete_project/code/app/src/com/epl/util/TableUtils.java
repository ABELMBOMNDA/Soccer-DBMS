package com.epl.util;

import javax.swing.JTable;
import javax.swing.ListSelectionModel;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;
import java.awt.Color;
import java.awt.Component;
import java.awt.Font;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.Vector;

public final class TableUtils {
    private TableUtils() {
    }

    public static DefaultTableModel toTableModel(ResultSet resultSet) throws Exception {
        ResultSetMetaData metaData = resultSet.getMetaData();
        int columnCount = metaData.getColumnCount();

        Vector<String> columns = new Vector<>();
        for (int i = 1; i <= columnCount; i++) {
            columns.add(metaData.getColumnLabel(i));
        }

        Vector<Vector<Object>> rows = new Vector<>();
        while (resultSet.next()) {
            Vector<Object> row = new Vector<>();
            for (int i = 1; i <= columnCount; i++) {
                row.add(resultSet.getObject(i));
            }
            rows.add(row);
        }

        return new DefaultTableModel(rows, columns) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
    }

    public static void configure(JTable table) {
        table.setRowHeight(26);
        table.setAutoCreateRowSorter(true);
        table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        table.setFillsViewportHeight(true);
        table.setGridColor(new Color(220, 220, 220));
        table.setShowHorizontalLines(true);
        table.setShowVerticalLines(false);

        JTableHeader header = table.getTableHeader();
        header.setReorderingAllowed(false);
        header.setFont(header.getFont().deriveFont(Font.BOLD));

        DefaultTableCellRenderer leftRenderer = new DefaultTableCellRenderer();
        leftRenderer.setHorizontalAlignment(DefaultTableCellRenderer.LEFT);

        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(DefaultTableCellRenderer.CENTER);

        table.setDefaultRenderer(Object.class, new ZebraRenderer(leftRenderer));
        table.setDefaultRenderer(Number.class, new ZebraRenderer(centerRenderer));
    }

    private static class ZebraRenderer extends DefaultTableCellRenderer {
        private final DefaultTableCellRenderer delegate;

        private ZebraRenderer(DefaultTableCellRenderer delegate) {
            this.delegate = delegate;
            this.delegate.setOpaque(true);
        }

        @Override
        public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected,
                                                       boolean hasFocus, int row, int column) {
            Component c = delegate.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column);
            if (!isSelected) {
                c.setBackground(row % 2 == 0 ? Color.WHITE : new Color(247, 247, 247));
            }
            return c;
        }
    }
}
