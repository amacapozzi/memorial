-- CreateEnum
CREATE TYPE "MessageKind" AS ENUM ('TEXT', 'AUDIO');

-- CreateEnum
CREATE TYPE "ReminderSource" AS ENUM ('MANUAL', 'AI');

-- CreateEnum
CREATE TYPE "ReminderStatus" AS ENUM ('ACTIVE', 'DONE', 'CANCELED');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('ONE_DAY_BEFORE', 'FIVE_HOURS_BEFORE', 'ON_TIME');

-- CreateEnum
CREATE TYPE "DeliveryStatus" AS ENUM ('PENDING', 'SENT', 'FAILED');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "phoneE164" TEXT NOT NULL,
    "name" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WaThread" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "waChatId" TEXT NOT NULL,
    "title" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "WaThread_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WaMessage" (
    "id" TEXT NOT NULL,
    "threadId" TEXT NOT NULL,
    "kind" "MessageKind" NOT NULL,
    "direction" TEXT NOT NULL,
    "waMsgId" TEXT,
    "text" TEXT,
    "mediaUrl" TEXT,
    "sentAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WaMessage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Reminder" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "threadId" TEXT,
    "source" "ReminderSource" NOT NULL DEFAULT 'AI',
    "status" "ReminderStatus" NOT NULL DEFAULT 'ACTIVE',
    "title" TEXT NOT NULL,
    "notes" TEXT,
    "dueAt" TIMESTAMP(3) NOT NULL,
    "createdFromMessageId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Reminder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReminderNotification" (
    "id" TEXT NOT NULL,
    "reminderId" TEXT NOT NULL,
    "type" "NotificationType" NOT NULL,
    "scheduledAt" TIMESTAMP(3) NOT NULL,
    "status" "DeliveryStatus" NOT NULL DEFAULT 'PENDING',
    "payloadText" TEXT,
    "sentAt" TIMESTAMP(3),
    "error" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ReminderNotification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CalendarLink" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "externalId" TEXT,
    "accessTokenEnc" TEXT,
    "refreshTokenEnc" TEXT,
    "expiresAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CalendarLink_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_phoneE164_key" ON "User"("phoneE164");

-- CreateIndex
CREATE INDEX "WaThread_userId_idx" ON "WaThread"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "WaThread_userId_waChatId_key" ON "WaThread"("userId", "waChatId");

-- CreateIndex
CREATE INDEX "WaMessage_threadId_sentAt_idx" ON "WaMessage"("threadId", "sentAt");

-- CreateIndex
CREATE INDEX "WaMessage_waMsgId_idx" ON "WaMessage"("waMsgId");

-- CreateIndex
CREATE INDEX "Reminder_userId_dueAt_idx" ON "Reminder"("userId", "dueAt");

-- CreateIndex
CREATE INDEX "Reminder_threadId_idx" ON "Reminder"("threadId");

-- CreateIndex
CREATE INDEX "Reminder_status_idx" ON "Reminder"("status");

-- CreateIndex
CREATE INDEX "ReminderNotification_scheduledAt_status_idx" ON "ReminderNotification"("scheduledAt", "status");

-- CreateIndex
CREATE UNIQUE INDEX "ReminderNotification_reminderId_type_key" ON "ReminderNotification"("reminderId", "type");

-- CreateIndex
CREATE INDEX "CalendarLink_userId_idx" ON "CalendarLink"("userId");

-- CreateIndex
CREATE INDEX "CalendarLink_provider_idx" ON "CalendarLink"("provider");

-- AddForeignKey
ALTER TABLE "WaThread" ADD CONSTRAINT "WaThread_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WaMessage" ADD CONSTRAINT "WaMessage_threadId_fkey" FOREIGN KEY ("threadId") REFERENCES "WaThread"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reminder" ADD CONSTRAINT "Reminder_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reminder" ADD CONSTRAINT "Reminder_threadId_fkey" FOREIGN KEY ("threadId") REFERENCES "WaThread"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reminder" ADD CONSTRAINT "Reminder_createdFromMessageId_fkey" FOREIGN KEY ("createdFromMessageId") REFERENCES "WaMessage"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReminderNotification" ADD CONSTRAINT "ReminderNotification_reminderId_fkey" FOREIGN KEY ("reminderId") REFERENCES "Reminder"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CalendarLink" ADD CONSTRAINT "CalendarLink_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
