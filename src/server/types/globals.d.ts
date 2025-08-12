/**
 * Global type declarations for server-side code
 */

// Re-export Cloudflare Workers types to ensure availability
declare global {
  // Cloudflare Workers Runtime Types
  interface ExecutionContext {
    waitUntil(promise: Promise<any>): void;
    passThroughOnException(): void;
  }

  interface ExportedHandler<Env = unknown> {
    fetch?(request: Request, env: Env, ctx: ExecutionContext): Response | Promise<Response>;
    scheduled?(event: ScheduledEvent, env: Env, ctx: ExecutionContext): void | Promise<void>;
    queue?(batch: MessageBatch<unknown>, env: Env, ctx: ExecutionContext): void | Promise<void>;
  }

  interface ScheduledEvent {
    type: 'scheduled';
    scheduledTime: number;
    cron: string;
    noRetry(): void;
  }

  interface MessageBatch<Body = unknown> {
    readonly queue: string;
    readonly messages: readonly Message<Body>[];
  }

  interface Message<Body = unknown> {
    readonly id: string;
    readonly timestamp: Date;
    readonly body: Body;
    ack(): void;
    retry(): void;
  }

  // D1 Database Types
  interface D1Database {
    prepare(query: string): D1PreparedStatement;
    dump(): Promise<ArrayBuffer>;
    batch<T = unknown>(statements: D1PreparedStatement[]): Promise<D1Result<T>[]>;
    exec(query: string): Promise<D1ExecResult>;
  }

  interface D1PreparedStatement {
    bind(...values: unknown[]): D1PreparedStatement;
    first<T = unknown>(colName?: string): Promise<T | null>;
    run(): Promise<D1Result>;
    all<T = unknown>(): Promise<D1Result<T>>;
    raw<T = unknown>(): Promise<T[]>;
  }

  interface D1Result<T = Record<string, unknown>> {
    success: boolean;
    results?: T[];
    meta: {
      duration: number;
      size_after: number;
      rows_read: number;
      rows_written: number;
    };
    error?: string;
    changes?: number;
  }

  interface D1ExecResult {
    count: number;
    duration: number;
  }

  // KV Namespace Types
  interface KVNamespace {
    get(key: string, options?: { type: 'text' | 'json' | 'arrayBuffer' | 'stream' }): Promise<any>;
    put(key: string, value: string | ArrayBuffer | ArrayBufferView | ReadableStream, options?: KVNamespacePutOptions): Promise<void>;
    delete(key: string): Promise<void>;
    list(options?: KVNamespaceListOptions): Promise<KVNamespaceListResult<any>>;
  }

  interface KVNamespacePutOptions {
    expiration?: number;
    expirationTtl?: number;
    metadata?: Record<string, unknown>;
  }

  interface KVNamespaceListOptions {
    limit?: number;
    prefix?: string;
    cursor?: string;
  }

  interface KVNamespaceListResult<Metadata> {
    keys: KVNamespaceListKey<Metadata>[];
    list_complete: boolean;
    cursor?: string;
  }

  interface KVNamespaceListKey<Metadata> {
    name: string;
    expiration?: number;
    metadata?: Metadata;
  }

  // Durable Objects Types
  interface DurableObjectNamespace {
    idFromName(name: string): DurableObjectId;
    idFromString(id: string): DurableObjectId;
    newUniqueId(): DurableObjectId;
    get(id: DurableObjectId): DurableObjectStub;
  }

  interface DurableObjectId {
    toString(): string;
    equals(other: DurableObjectId): boolean;
  }

  interface DurableObjectStub {
    fetch(request: Request): Promise<Response>;
    id: DurableObjectId;
  }

  // Queue Types
  interface Queue {
    send(body: unknown, options?: QueueSendOptions): Promise<void>;
    sendBatch(messages: QueueSendBatchMessage[], options?: QueueSendBatchOptions): Promise<void>;
  }

  interface QueueSendOptions {
    delaySeconds?: number;
  }

  interface QueueSendBatchMessage {
    body: unknown;
    delaySeconds?: number;
  }

  interface QueueSendBatchOptions {
    delaySeconds?: number;
  }

  // Analytics Engine Types
  interface AnalyticsEngine {
    writeDataPoint(event: AnalyticsEngineDataPoint): void;
  }

  interface AnalyticsEngineDataPoint {
    doubles?: number[];
    blobs?: string[];
    indexes?: string[];
  }

  // Fetcher for Service Bindings
  interface Fetcher {
    fetch(input: RequestInfo, init?: RequestInit): Promise<Response>;
  }

  // Node.js types that might be needed
  namespace NodeJS {
    interface Timeout {
      ref(): this;
      unref(): this;
    }
  }

  declare var process: {
    env: {
      NODE_ENV?: string;
      [key: string]: string | undefined;
    };
  };

  declare var __dirname: string;
  declare var __filename: string;
}

export {};