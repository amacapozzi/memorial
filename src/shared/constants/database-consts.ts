import { env } from "elysia";
import z from "zod";

const databaseConfigSchema = z.object({
  databaseUrl: z.string()
});

export type dbConfig = z.infer<typeof databaseConfigSchema>;

export const dbConfig = databaseConfigSchema.parse(env);
