import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DBConnection {

    private static final String URL = System.getenv().getOrDefault(
        "KEC_EVAL_DB_URL",
        "jdbc:mysql://localhost:3306/kec_eval_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&createDatabaseIfNotExist=true"
    );

    private static final String USER =
        System.getenv().getOrDefault("KEC_DB_USER", "root");

    private static final String PASSWORD =
        System.getenv().getOrDefault("KEC_DB_PASSWORD", "");

    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static boolean testConnection() {
        try (Connection connection = getConnection()) {
            return connection.isValid(3);
        } catch (SQLException e) {
            System.err.println("[ERROR] MySQL connection failed: " + e.getMessage());
            return false;
        }
    }

    public static String getDbUrl() {
        return URL;
    }
}
