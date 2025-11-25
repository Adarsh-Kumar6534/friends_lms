const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const { google } = require("googleapis");

admin.initializeApp();

const db = admin.firestore();

// Load Service Account
// User must place 'service-account.json' in the functions directory
const serviceAccount = require("./service-account.json");

// Configure Nodemailer with Service Account (using Gmail API via OAuth2/Service Account)
// Note: For Gmail, using Service Account directly often requires Domain-Wide Delegation.
// If that's not possible, we might need to use a standard OAuth2 refresh token or App Password.
// However, the user specifically asked for Service Account.
// We will try to use the 'googleapis' to send email if nodemailer fails, or configure nodemailer with OAuth2 from service account.

// Strategy: Use googleapis to send email
async function sendEmail(to, subject, text) {
  try {
    const jwtClient = new google.auth.JWT(
      serviceAccount.client_email,
      null,
      serviceAccount.private_key,
      ["https://www.googleapis.com/auth/gmail.send"]
    );

    await jwtClient.authorize();

    const gmail = google.gmail({ version: "v1", auth: jwtClient });

    const utf8Subject = `=?utf-8?B?${Buffer.from(subject).toString("base64")}?=`;
    const messageParts = [
      `From: Friends LMS <${serviceAccount.client_email}>`,
      `To: ${to}`,
      `Subject: ${utf8Subject}`,
      "Content-Type: text/plain; charset=utf-8",
      "MIME-Version: 1.0",
      "",
      text,
    ];
    const message = messageParts.join("\n");

    const encodedMessage = Buffer.from(message)
      .toString("base64")
      .replace(/\+/g, "-")
      .replace(/\//g, "_")
      .replace(/=+$/, "");

    await gmail.users.messages.send({
      userId: "me",
      requestBody: {
        raw: encodedMessage,
      },
    });
    console.log(`Email sent to ${to}`);
  } catch (error) {
    console.error("Error sending email:", error);
    // Fallback or re-throw
  }
}

// Scheduled function to check for reminders
// Runs every hour
exports.checkReminders = functions.pubsub
  .schedule("every 1 hours")
  .onRun(async (context) => {
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    
    // Query active reminders
    const snapshot = await db.collection("reminders").where("status", "==", "active").get();

    if (snapshot.empty) {
      console.log("No active reminders found.");
      return null;
    }

    const promises = [];

    snapshot.forEach((doc) => {
      const reminder = doc.data();
      const eventDate = reminder.eventDate.toDate();
      const daysBefore = reminder.daysBefore || 1;
      
      // Calculate notification date
      const notificationDate = new Date(eventDate);
      notificationDate.setDate(eventDate.getDate() - daysBefore);

      // Check if today is the notification date
      if (
        today.getFullYear() === notificationDate.getFullYear() &&
        today.getMonth() === notificationDate.getMonth() &&
        today.getDate() === notificationDate.getDate()
      ) {
        // Send Email
        const subject = `Reminder: ${reminder.title}`;
        const text = `Hello,\n\nThis is a reminder for your upcoming ${reminder.type}: ${reminder.title}.\nIt is scheduled for ${eventDate.toDateString()}.\n\nGood luck!\nFriends LMS`;
        
        promises.push(sendEmail(reminder.email, subject, text));
      }
    });

    await Promise.all(promises);
    return null;
  });
