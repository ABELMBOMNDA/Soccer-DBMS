package com.epl;

import com.epl.ui.MainFrame;

import javax.swing.SwingUtilities;

public class Main {
    public static void main(String[] args) {
        MainFrame.applySystemLookAndFeel();
        SwingUtilities.invokeLater(() -> new MainFrame().setVisible(true));
    }
}
