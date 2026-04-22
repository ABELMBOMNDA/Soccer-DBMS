package com.epl.db;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class DBConnection {
    private DBConnection() {
    }

    private static Properties loadProperties() throws IOException {
        Properties properties = new Properties();

        // 1) External config next to the working directory / jar
        Path externalPath = Paths.get("db.properties");
        if (Files.exists(externalPath)) {
            try (InputStream input = Files.newInputStream(externalPath)) {
                properties.load(input);
                return properties;
            }
        }

        // 2) Resource bundled with the application
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                properties.load(input);
                return properties;
            }
        }

        throw new IOException(
                "Database configuration was not found. Place db.properties in the same folder as the JAR " +
                "or add it to the application resources."
        );
    }

    public static Connection getConnection() throws SQLException {
        try {
            Properties properties = loadProperties();
            String url = properties.getProperty("db.url", "").trim();
            String user = properties.getProperty("db.user", "").trim();
            String password = properties.getProperty("db.password", "").trim();

            if (url.isEmpty()) {
                throw new IllegalStateException("db.url is missing in db.properties.");
            }

            return DriverManager.getConnection(url, user, password);
        } catch (IOException ex) {
            throw new IllegalStateException(ex.getMessage(), ex);
        }
    }
}
