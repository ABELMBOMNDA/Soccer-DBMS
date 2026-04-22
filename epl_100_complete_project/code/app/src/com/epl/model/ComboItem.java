package com.epl.model;

public class ComboItem {
    private final int id;
    private final String label;

    public ComboItem(int id, String label) {
        this.id = id;
        this.label = label == null ? "" : label;
    }

    public int getId() {
        return id;
    }

    public String getLabel() {
        return label;
    }

    @Override
    public String toString() {
        return label;
    }
}
