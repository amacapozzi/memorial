import { PrismaPg } from "@prisma/adapter-pg";
import { env } from "bun";

import { PrismaClient } from "src/prisma/generated/prisma/client";

const databaseUrl = env.DATABASE_URL;

if (!databaseUrl) {
  throw new Error("DATABASE_URL is not set");
}

const adapter = new PrismaPg({ connectionString: databaseUrl });
export const prisma = new PrismaClient({ adapter });
