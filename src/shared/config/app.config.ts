import { z } from "zod";

const AppConfigSchema = z.object({
  NODE_ENV: z.enum(["development", "test", "production"]).default("development"),

  APP_NAME: z.string().min(1).default("memorial-bot"),

  PORT: z.coerce.number().int().min(1).max(65535).default(3000)
});

const parsed = AppConfigSchema.safeParse(process.env);

if (!parsed.success) {
  console.error("❌ Invalid application configuration");
  console.error(parsed.error.format());
  process.exit(1);
}

export const appConfig = Object.freeze({
  ...parsed.data,

  isDev: parsed.data.NODE_ENV === "development",
  isProd: parsed.data.NODE_ENV === "production",
  isTest: parsed.data.NODE_ENV === "test"
});

export type AppConfig = z.infer<typeof AppConfigSchema>;
