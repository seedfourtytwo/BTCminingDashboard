/**
 * Base repository class with common CRUD operations
 */

import type { DatabaseConnection } from './connection';
import type { PaginationParams, PaginationMeta } from '../../types/api';

export interface BaseEntity {
  id: string;
  created_at: string;
  updated_at: string;
}

export interface PaginatedResult<T> {
  data: T[];
  pagination: PaginationMeta;
}

export abstract class BaseRepository<T extends BaseEntity> {
  constructor(
    protected connection: DatabaseConnection,
    protected tableName: string
  ) {}

  /**
   * Generate a unique ID for new entities
   */
  protected generateId(): string {
    return crypto.randomUUID();
  }

  /**
   * Find entity by ID
   */
  async findById(id: string): Promise<T | null> {
    return await this.connection.first<T>(
      `SELECT * FROM ${this.tableName} WHERE id = ?`,
      [id]
    );
  }

  /**
   * Find multiple entities with pagination
   */
  async findMany(params: PaginationParams = {}): Promise<PaginatedResult<T>> {
    const {
      page = 1,
      per_page = 20,
      sort_by = 'created_at',
      sort_order = 'desc'
    } = params;

    const offset = (page - 1) * per_page;
    const limit = per_page;

    // Validate and sanitize sort parameters to prevent SQL injection
    const allowedSortColumns = new Set(['id', 'created_at', 'updated_at', 'name']);
    const allowedSortOrder: Record<string, 'ASC' | 'DESC'> = { 
      asc: 'ASC', 
      desc: 'DESC' 
    };
    
    const sortColumn = allowedSortColumns.has(sort_by || '') ? sort_by! : 'created_at';
    const sortDirection = allowedSortOrder[(sort_order || 'desc').toLowerCase()] ?? 'DESC';

    // Get total count
    const countResult = await this.connection.first<{ count: number }>(
      `SELECT COUNT(*) as count FROM ${this.tableName}`
    );
    const total = countResult?.count || 0;

    // Get paginated data with safe ORDER BY
    const dataResult = await this.connection.execute<T>(
      `SELECT * FROM ${this.tableName} 
       ORDER BY ${sortColumn} ${sortDirection} 
       LIMIT ? OFFSET ?`,
      [limit, offset]
    );

    const total_pages = Math.ceil(total / per_page);

    return {
      data: dataResult.results || [],
      pagination: {
        page,
        per_page,
        total,
        total_pages,
        has_next: page < total_pages,
        has_prev: page > 1
      }
    };
  }

  /**
   * Create a new entity
   */
  async create(data: Omit<T, 'id' | 'created_at' | 'updated_at'>): Promise<T> {
    const id = this.generateId();
    const now = new Date().toISOString();
    
    const entityData = {
      ...data,
      id,
      created_at: now,
      updated_at: now
    };

    const columns = Object.keys(entityData);
    const placeholders = columns.map(() => '?').join(', ');
    const values = Object.values(entityData);

    await this.connection.run(
      `INSERT INTO ${this.tableName} (${columns.join(', ')}) VALUES (${placeholders})`,
      values
    );

    const created = await this.findById(id);
    if (!created) {
      throw new Error(`Failed to create entity in ${this.tableName}`);
    }

    return created;
  }

  /**
   * Update an existing entity
   */
  async update(id: string, data: Partial<Omit<T, 'id' | 'created_at'>>): Promise<T> {
    const updateData = {
      ...data,
      updated_at: new Date().toISOString()
    };

    const columns = Object.keys(updateData);
    const setClause = columns.map(col => `${col} = ?`).join(', ');
    const values = [...Object.values(updateData), id];

    const result = await this.connection.run(
      `UPDATE ${this.tableName} SET ${setClause} WHERE id = ?`,
      values
    );

    if (!result.changes || result.changes === 0) {
      throw new Error(`Entity with id ${id} not found in ${this.tableName}`);
    }

    const updated = await this.findById(id);
    if (!updated) {
      throw new Error(`Failed to fetch updated entity from ${this.tableName}`);
    }

    return updated;
  }

  /**
   * Delete an entity by ID
   */
  async delete(id: string): Promise<boolean> {
    const result = await this.connection.run(
      `DELETE FROM ${this.tableName} WHERE id = ?`,
      [id]
    );

    return result.changes !== undefined && result.changes > 0;
  }

  /**
   * Check if entity exists
   */
  async exists(id: string): Promise<boolean> {
    const result = await this.connection.first<{ count: number }>(
      `SELECT COUNT(*) as count FROM ${this.tableName} WHERE id = ?`,
      [id]
    );

    return (result?.count || 0) > 0;
  }

  /**
   * Count total entities
   */
  async count(): Promise<number> {
    const result = await this.connection.first<{ count: number }>(
      `SELECT COUNT(*) as count FROM ${this.tableName}`
    );

    return result?.count || 0;
  }

  /**
   * Execute a custom query for this table
   */
  protected async query<R = T>(
    sql: string,
    params: unknown[] = []
  ): Promise<R[]> {
    const result = await this.connection.execute<R>(sql, params);
    return result.results || [];
  }

  /**
   * Execute a custom query and return first result
   */
  protected async queryFirst<R = T>(
    sql: string,
    params: unknown[] = []
  ): Promise<R | null> {
    return await this.connection.first<R>(sql, params);
  }

  /**
   * Build WHERE clause for filtering
   */
  protected buildWhereClause(
    filters: Record<string, unknown>,
    baseParams: unknown[] = []
  ): { whereClause: string; params: unknown[] } {
    const conditions: string[] = [];
    const params = [...baseParams];

    for (const [key, value] of Object.entries(filters)) {
      if (value !== undefined && value !== null) {
        if (Array.isArray(value)) {
          const placeholders = value.map(() => '?').join(', ');
          conditions.push(`${key} IN (${placeholders})`);
          params.push(...value);
        } else if (key.endsWith('_min')) {
          const column = key.replace('_min', '');
          conditions.push(`${column} >= ?`);
          params.push(value);
        } else if (key.endsWith('_max')) {
          const column = key.replace('_max', '');
          conditions.push(`${column} <= ?`);
          params.push(value);
        } else if (key.endsWith('_like')) {
          const column = key.replace('_like', '');
          conditions.push(`${column} LIKE ?`);
          params.push(`%${value}%`);
        } else {
          conditions.push(`${key} = ?`);
          params.push(value);
        }
      }
    }

    const whereClause = conditions.length > 0 
      ? `WHERE ${conditions.join(' AND ')}`
      : '';

    return { whereClause, params };
  }

  /**
   * Build ORDER BY clause
   */
  protected buildOrderClause(
    sortBy?: string,
    sortOrder: 'asc' | 'desc' = 'desc'
  ): string {
    if (!sortBy) {
      return 'ORDER BY created_at DESC';
    }

    return `ORDER BY ${sortBy} ${sortOrder.toUpperCase()}`;
  }

  /**
   * Build LIMIT and OFFSET clause
   */
  protected buildLimitClause(page: number = 1, perPage: number = 20): {
    limitClause: string;
    offset: number;
    limit: number;
  } {
    const offset = (page - 1) * perPage;
    const limit = perPage;
    const limitClause = `LIMIT ${limit} OFFSET ${offset}`;

    return { limitClause, offset, limit };
  }
}