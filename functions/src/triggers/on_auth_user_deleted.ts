import * as admin from 'firebase-admin';
import * as functionsV1 from 'firebase-functions/v1';
import { cleanupDeletedUser } from '../utils/account_cleanup';

/**
 * Runs after a Firebase Auth user is deleted (from the app's "Delete account"
 * or from the admin dashboard) and removes that account's own Firestore docs
 * and Storage uploads with admin rights.
 *
 * The app deletes the login FIRST and relies on this function for the data:
 * once the login is gone the app could no longer delete anything itself, and
 * deleting data first used to leave "account exists, profile gone" users
 * whenever Firebase demanded a recent sign-in.
 *
 * Auth delete triggers are only available in the v1 API.
 */
export const onAuthUserDeleted = functionsV1.auth.user().onDelete(async (user) => {
  await cleanupDeletedUser(admin.firestore(), admin.storage().bucket(), user.uid);
});
