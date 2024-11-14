const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Cloud Function para crear un usuario de médico
exports.createMedicoUser = functions.https.onCall(async (data, context) => {
  // Verificar que el usuario esté autenticado
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "El usuario debe estar autenticado.");
  }

  try {
    const { email, password, nombre, apellido, especialidad, area } = data;

    // Crear el usuario en Firebase Authentication
    const userRecord = await admin.auth().createUser({
      email: email,
      password: password,
      displayName: `${nombre} ${apellido}`,
    });

    // Guardar los detalles del médico en Firestore
    await admin.firestore().collection("medicos").doc(userRecord.uid).set({
      uid: userRecord.uid,
      nombre: nombre,
      apellido: apellido,
      especialidad: especialidad,
      area: area,
      usuario: email,
    });

    return { uid: userRecord.uid, email: userRecord.email };
  } catch (error) {
    throw new functions.https.HttpsError("internal", error.message);
  }
});