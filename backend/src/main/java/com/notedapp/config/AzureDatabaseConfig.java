package com.notedapp.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.Profile;

import javax.sql.DataSource;

/**
 * Production Database Configuration for Azure MySQL
 * 
 * This class configures a HikariCP connection pool for the Azure MySQL database
 * in the production environment. It reads configuration from environment variables:
 * AZURE_MYSQL_URL, AZURE_MYSQL_USERNAME, and AZURE_MYSQL_PASSWORD.
 * 
 * Note: This class is only active when the "prod" profile is enabled.
 */
@Configuration
@Profile("prod")
public class AzureDatabaseConfig {
    private static final Logger logger = LoggerFactory.getLogger(AzureDatabaseConfig.class);

    @Value("${AZURE_MYSQL_URL}")
    private String jdbcUrl;
    
    @Value("${AZURE_MYSQL_USERNAME}")
    private String username;
    
    @Value("${AZURE_MYSQL_PASSWORD}")
    private String password;
    
    /**
     * Creates and configures the production DataSource with HikariCP
     * 
     * @return A configured DataSource for the production environment
     */
    @Bean
    @Primary
    public DataSource dataSource() {
        logger.info("Initializing production DataSource with Azure MySQL configuration");
        HikariConfig config = new HikariConfig();
        
        // Essential connection properties
        config.setJdbcUrl(jdbcUrl);
        config.setUsername(username);
        config.setPassword(password);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
        
        // Connection pool settings
        config.setConnectionTimeout(30000); // 30 seconds
        config.setMinimumIdle(5);
        config.setMaximumPoolSize(10);
        config.setPoolName("KrabbelHikariPool");
        config.setAutoCommit(true);
        config.setConnectionTestQuery("SELECT 1");
        
        // Additional production settings
        config.setMaxLifetime(1800000); // 30 minutes
        config.setIdleTimeout(600000);  // 10 minutes
        
        logger.debug("Azure MySQL JDBC URL: {}", jdbcUrl);
        logger.debug("Connection pool size: min={}, max={}", config.getMinimumIdle(), config.getMaximumPoolSize());
        
        return new HikariDataSource(config);
    }
}
