import { Store } from "whatsapp-web.js";

import { prisma } from "./prisma";

export class PrismaSessionStore extends Store {
  constructor() {
    super();
  }

  async sessionExists(options: { session: string }): Promise<boolean> {
    const found = await prisma.waSession.findUnique({
      where: { id: options.session }
    });
    return !!found;
  }

  async save(options: { session: string }, sessionData?: any): Promise<void> {
    if (!sessionData) return;

    await prisma.waSession.upsert({
      where: { id: options.session },
      update: { data: sessionData },
      create: {
        id: options.session,
        data: sessionData
      }
    });
  }

  async extract(options: { session: string }): Promise<any> {
    const found = await prisma.waSession.findUnique({
      where: { id: options.session }
    });
    return found?.data || null;
  }

  async delete(options: { session: string }): Promise<void> {
    await prisma.waSession
      .delete({
        where: { id: options.session }
      })
      .catch(() => {});
  }
}
