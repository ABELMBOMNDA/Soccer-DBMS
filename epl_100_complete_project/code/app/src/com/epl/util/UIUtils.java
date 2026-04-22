package com.epl.util;

import javax.swing.JOptionPane;
import javax.swing.JTextField;
import java.awt.Component;

public final class UIUtils {
    private UIUtils() {
    }

    public static String required(JTextField field, String label) {
        String value = field.getText() == null ? "" : field.getText().trim();
        if (value.isEmpty()) {
            throw new IllegalArgumentException(label + " is required.");
        }
        return value;
    }

    public static int parseInteger(String value, String label) {
        try {
            return Integer.parseInt(value.trim());
        } catch (Exception ex) {
            throw new IllegalArgumentException(label + " must be a valid whole number.");
        }
    }

    public static double parseDouble(String value, String label) {
        try {
            return Double.parseDouble(value.trim());
        } catch (Exception ex) {
            throw new IllegalArgumentException(label + " must be a valid number.");
        }
    }

    public static void showError(Component parent, Exception ex) {
        String message = ex.getMessage();
        if (message == null || message.isBlank()) {
            message = ex.getClass().getSimpleName();
        }
        JOptionPane.showMessageDialog(parent, message, "Error", JOptionPane.ERROR_MESSAGE);
    }

    public static void showInfo(Component parent, String message) {
        JOptionPane.showMessageDialog(parent, message, "Success", JOptionPane.INFORMATION_MESSAGE);
    }
}
