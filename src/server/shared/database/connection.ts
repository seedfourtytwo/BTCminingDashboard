/**
 * Database connection utilities for D1
 */

import type { APIWorkerEnv } from '../../types/environment';

export class DatabaseConnection {
  private constructor(private db: D1Database) {}

  static create(env: APIWorkerEnv): DatabaseConnection {
    if (!env.DB) {
      throw new Error('Database binding not found in environment');
    }
    return new DatabaseConnection(env.DB);
  }

  get database(): D1Database {
    return this.db;
  }

  /**
   * Execute a prepared statement with error handling
   */
  async execute<T = unknown>(query: string, params: unknown[] = []): Promise<D1Result<T>> {
    try {
      const stmt = this.db.prepare(query);
      const result = params.length > 0 ? await stmt.bind(...params).all() : await stmt.all();

      return result as D1Result<T>;
    } catch (error) {
      console.error('Database query error:', { query, params, error });
      throw new DatabaseError(
        `Query execution failed: ${error instanceof Error ? error.message : 'Unknown error'}`,
        { query, params, originalError: error }
      );
    }
  }

  /**
   * Execute a prepared statement and return first result
   */
  async first<T = unknown>(query: string, params: unknown[] = []): Promise<T | null> {
    try {
      const stmt = this.db.prepare(query);
      const result = params.length > 0 ? await stmt.bind(...params).first() : await stmt.first();

      return result as T | null;
    } catch (error) {
      console.error('Database query error:', { query, params, error });
      throw new DatabaseError(
        `Query execution failed: ${error instanceof Error ? error.message : 'Unknown error'}`,
        { query, params, originalError: error }
      );
    }
  }

  /**
   * Execute a mutation query (INSERT, UPDATE, DELETE)
   */
  async run(query: string, params: unknown[] = []): Promise<D1Result> {
    try {
      const stmt = this.db.prepare(query);
      const result = params.length > 0 ? await stmt.bind(...params).run() : await stmt.run();

      return result;
    } catch (error) {
      console.error('Database mutation error:', { query, params, error });
      throw new DatabaseError(
        `Mutation execution failed: ${error instanceof Error ? error.message : 'Unknown error'}`,
        { query, params, originalError: error }
      );
    }
  }

  /**
   * Execute multiple statements in a transaction
   */
  async transaction<T>(operations: ((db: D1Database) => Promise<T>)[]): Promise<T[]> {
    try {
      // Note: D1 doesn't support explicit transactions yet
      // This is a sequential execution pattern
      const results: T[] = [];

      for (const operation of operations) {
        const result = await operation(this.db);
        results.push(result);
      }

      return results;
    } catch (error) {
      console.error('Transaction error:', error);
      throw new DatabaseError(
        `Transaction failed: ${error instanceof Error ? error.message : 'Unknown error'}`,
        { operationCount: operations.length, originalError: error }
      );
    }
  }

  /**
   * Check database connectivity
   */
  async healthCheck(): Promise<boolean> {
    try {
      await this.first('SELECT 1 as test');
      return true;
    } catch (error) {
      console.error('Database health check failed:', error);
      return false;
    }
  }

  /**
   * Get database info (for debugging)
   */
  async getInfo(): Promise<{ connected: boolean; timestamp: string }> {
    try {
      const result = await this.first<{ test: number; timestamp: string }>(
        'SELECT 1 as test, datetime("now") as timestamp'
      );

      return {
        connected: result?.test === 1,
        timestamp: result?.timestamp || 'unknown',
      };
    } catch (error) {
      return {
        connected: false,
        timestamp: new Date().toISOString(),
      };
    }
  }
}

export class DatabaseError extends Error {
  constructor(
    message: string,
    public readonly context?: Record<string, unknown>
  ) {
    super(message);
    this.name = 'DatabaseError';
  }
}

// Migration utilities
export interface Migration {
  version: number;
  name: string;
  sql: string;
}

export class MigrationManager {
  constructor(private connection: DatabaseConnection) {}

  /**
   * Run pending migrations
   */
  async runMigrations(migrations: Migration[]): Promise<void> {
    const db = this.connection.database;

    // Create migrations table if it doesn't exist
    await db.exec(`
      CREATE TABLE IF NOT EXISTS migrations (
        version INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        executed_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // Get current version
    const current = await this.connection.first<{ version: number }>(
      'SELECT MAX(version) as version FROM migrations'
    );
    const currentVersion = current?.version || 0;

    // Run pending migrations
    for (const migration of migrations) {
      if (migration.version > currentVersion) {
        console.log(`Running migration ${migration.version}: ${migration.name}`);

        try {
          await db.exec(migration.sql);
          await this.connection.run('INSERT INTO migrations (version, name) VALUES (?, ?)', [
            migration.version,
            migration.name,
          ]);

          console.log(`Migration ${migration.version} completed successfully`);
        } catch (error) {
          console.error(`Migration ${migration.version} failed:`, error);
          throw new DatabaseError(
            `Migration ${migration.version} failed: ${error instanceof Error ? error.message : 'Unknown error'}`,
            { migration, originalError: error }
          );
        }
      }
    }
  }

  /**
   * Get migration status
   */
  async getMigrationStatus(): Promise<{ version: number; name: string; executed_at: string }[]> {
    const result = await this.connection.execute<{
      version: number;
      name: string;
      executed_at: string;
    }>('SELECT version, name, executed_at FROM migrations ORDER BY version');

    return result.results || [];
  }
}
