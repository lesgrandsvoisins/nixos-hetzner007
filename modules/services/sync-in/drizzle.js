import { defineConfig } from "drizzle-kit";

export default defineConfig({
  dialect: "mysql",
  schema: "./release/sync-in-server/server/infrastructure/database/schema.js",
  out: "./backend/migrations",
  url: "mysql://root@localhost/syncin",
  tablesFilter: [
    'files_content_*'
  ]
});